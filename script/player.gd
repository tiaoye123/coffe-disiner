extends CharacterBody2D

#角色移动判断（不要和全局变量里面那个玩家移动搞混了，这个不ban重力的）
var character_can_move : bool = true
@export var move_speed : float = 85
@export var jump_speed : float = -185
@export var dash_speed : float = 280
@export var dash_time : float = 0.1
var F : float = 0.8
@export var G : float = 500
var dash_input : Vector2
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animationtree_play_back = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var node_2d_2: Node2D = $"../Node2D2"
@onready var 疯狂粒子: GPUParticles2D = $疯狂粒子
@onready var 泪水01: GPUParticles2D = $泪水01
@onready var 泪水02: GPUParticles2D = $泪水02
@onready var 走路粒子: GPUParticles2D = $走路粒子
@onready var 二段跳粒子: GPUParticles2D = $二段跳粒子
var 落地尘埃开关 : bool = true
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


var start_position = Vector2(56 , 105)


#随着状态减少改变角色粒子效果的数量
var 最大泪水粒子数 : float = 8
var 泪水粒子数 : float:
	set(value):
		泪水01.amount_ratio = value
		泪水02.amount_ratio = value
var 疯狂粒子数 : float:
	set(value):
		疯狂粒子.amount = value
var 最大疯狂粒子数 : float = 150
var crasy_rate : float:
	set(value):
		crasy_rate = value
		if crasy_rate <= 1:
			疯狂粒子数 = 最大疯狂粒子数 * (1 - crasy_rate)
			泪水粒子数 = 1 - crasy_rate

const 冲刺残影 = preload("res://scenes/冲刺残影.tscn")
const 落地尘埃 = preload("res://scenes/落地尘埃.tscn")
var can_double_jump : bool = false
var player_have_double_jump : bool = false
#玩家所拥有的增益列表
var buff_list : Array[String]

#动画树判定用变量
var woof_time : bool
var woof_time_index : float
var jump_start : bool = false
var jump_over : bool = false
var jump_timer : float
var can_stop_jump : bool
var dash_start : bool = false
var dash_over : bool = false
var dash_timer : float
var update_dash_timer : float:
	set(value):
		if update_dash_timer * value <= 0:
			dash_CD = 1
			if update_dash_timer == 1 and velocity.y >= 0:
				创建落地尘埃()
		update_dash_timer = value
var can_dash : bool = false
var dash_CD: float = 1
var dash_shadow_button : bool = false
var dead_timer : float = 0
#这仨用于冲刺教程的过场动画
var is_player_get_dash : bool = false
var start_dash_check : bool = false
var time_tween : Tween

func _ready() -> void:
	冲刺残影检定()
	Global.get_coffe_buff.connect(增益添加)
	Global.enter_to_crasy.connect(增益消除)
	Global.enter_to_crasy.connect(enter_creasy)
	Global.get_coffe_buff.connect(get_coffe)
	Global.死亡转场结束.connect(respawn)
	global_position = start_position


func _process(delta: float) -> void:
	
	#向全局变量传递玩家实时位置
	Global.player_position = global_position
	
	#判断此时玩家是否可移动
	if not Global.player_can_move:
		return
	
	#郊狼时间判定
	if is_on_floor():
		woof_time = true
		woof_time_index = 0
	else:
		woof_time_index += 60 * delta
		if woof_time_index >= 2.5:
			woof_time = false
	
	crasy_rate = Global.crasy_rate
	
	Global.position_for_buff_ball.emit(global_position , sprite_2d.flip_h)
	
	#冲刺cd计算
	dash_CD += delta
	
	#以字符串返回当前所处的动画状态机
	var state = animationtree_play_back.get_current_node()
	
	
	if is_on_floor():
		can_double_jump = true
		can_dash = true
		update_dash_timer = -1
	else:
		update_dash_timer = 1
	
	#冲刺判定
	if can_dash and dash_CD >= 0.5 and Input.is_action_just_pressed("dash") and is_player_get_dash:
		dash_start = true
		dash_timer = 0
		dash_CD = 0
	
	match state:
		"角色移动":
			#刷新冲刺和二段跳
			velocity.y += G * delta #玩家重力
			#获取玩家输入方向键
			var direct := Input.get_axis("move_left","move_right")
			if not character_can_move:
				direct = 0
			if direct:
				velocity.x = move_speed * direct
				change_the_face(direct)
			else:
				velocity.x = move_toward(velocity.x, 0, move_speed)
			if Input.is_action_just_pressed("jump") and woof_time and character_can_move:
				jump_start = true
				velocity.y = jump_speed
				jump_timer = 0
			elif Input.is_action_just_pressed("jump") and can_double_jump and player_have_double_jump and character_can_move:
				二段跳粒子发射()
				jump_start = true
				velocity.y = jump_speed
				jump_timer = 0
				can_double_jump = false
		"角色跳跃":
			#计时
			jump_timer += delta
			jump_over = false
			jump_start = false
			if not is_on_floor():
				velocity.y += G * delta
			var direct := Input.get_axis("move_left","move_right")
			if not character_can_move:
				direct = 0
			velocity.x = move_speed * direct
			if direct:
				change_the_face(direct)
			if jump_timer <= 0.05:
				can_stop_jump = false
			if jump_timer >= 0.05:
				can_stop_jump = true
				if can_stop_jump and not Input.is_action_pressed("jump"):
					jump_over = true
					velocity.y = 5
			if velocity.y >= 0:
				jump_over = true
				velocity.y = 0
		"角色冲刺":
			dash_shadow_button = true
			dash_over = false
			dash_start = false
			dash_timer += delta
			can_dash = false
			if dash_timer >= 0.03:
				velocity = dash_input * dash_speed
			if dash_timer >= 0.15:
				dash_over = true
				dash_shadow_button = false
		"角色死亡":
			dead_timer += delta
			if dead_timer <= 0.6:
				velocity.y += G * delta
			else:
				velocity.y = 0
			
	
	#走路粒子的启用
	if velocity.x == 0 and is_on_floor():
		走路粒子.emitting = false
	else:
		走路粒子.emitting = true
	
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("trap"):
			dead()
	


#在动画状态机中更改朝向
func change_the_face(direct) -> void:
	dash_input.x = direct
	animation_tree.set("parameters/StateMachine/角色移动/nromal/blend_position",direct)
	animation_tree.set("parameters/StateMachine/角色跳跃/BlendSpace1D/blend_position",direct)
	animation_tree.set("parameters/StateMachine/角色冲刺/BlendSpace1D/blend_position",direct) 


#角色冲刺残影动画检定
func 冲刺残影检定() -> void:
	if dash_shadow_button == true:
		冲刺残影创建()
		await get_tree().create_timer(0.05).timeout
		冲刺残影检定()
	else:
		await get_tree().create_timer(0.05).timeout
		冲刺残影检定()


func 冲刺残影创建() -> void:
	var p = 冲刺残影.instantiate()
	node_2d_2.add_child(p)
	p.instiantial(sprite_2d.frame , global_position , sprite_2d.flip_h)


func 二段跳粒子发射():
	二段跳粒子.emitting = true
	await get_tree().create_timer(0.01).timeout
	二段跳粒子停止()


func 二段跳粒子停止() -> void:
	二段跳粒子.emitting = false


#向buff列表添加玩家触发的增益
func 增益添加(buff_name : String):
	if not buff_list.has(buff_name):
		buff_list.append(buff_name)
		增益检定()


#检定玩家增益并修改相应数值
func 增益检定():
	var double_jump : int = 0
	for i in buff_list:
		if i == "二段跳":
			double_jump += 1
	if double_jump >= 1:
		player_have_double_jump = true
	else:
		player_have_double_jump = false


#消除玩家触发的所有增益
func 增益消除():
	buff_list.clear()
	增益检定()


func enter_creasy() -> void:
	疯狂粒子.emitting = true
	泪水01.emitting = true
	泪水02.emitting = true


func get_coffe(a):
	疯狂粒子.emitting = false
	泪水01.emitting = false
	泪水02.emitting = false


#第一次踩到破碎平台后的冲刺教学的演出
func 冲刺教学演出() -> void:
	character_can_move = false
	time_tween = create_tween()
	time_tween.tween_property(Engine , "time_scale" , 0 , 0.56)
	await get_tree().create_timer(2.0 , true , false , true).timeout
	Global.冲刺按键提示.emit()
	await get_tree().create_timer(0.5 , true , false , true).timeout
	start_dash_check = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash") and start_dash_check:
		time_tween.kill()
		dash_start = true
		Engine.time_scale = 1.0
		character_can_move = true
		is_player_get_dash = true
		start_dash_check = false
	return


func change_start_position(value : Vector2) -> void:
	start_position = value


#角色死亡
func dead() -> void:
	疯狂粒子.emitting = false
	泪水01.emitting = false
	泪水02.emitting = false
	velocity.y = -100
	velocity.x = 0
	character_can_move = false
	走路粒子.visible = false
	疯狂粒子.visible = false
	泪水01.visible = false
	泪水02.visible = false
	落地尘埃开关 = false
	collision_shape_2d.disabled = true
	dead_timer = 0
	animationtree_play_back.travel("角色死亡")
	await get_tree().create_timer(0.65).timeout
	Global.玩家死亡转场.emit()
	增益消除()


#角色重生
func respawn() -> void:
	global_position = start_position
	character_can_move = true
	走路粒子.visible = true
	疯狂粒子.visible = true
	泪水01.visible = true
	泪水02.visible = true
	落地尘埃开关 = true
	collision_shape_2d.disabled = false


func 创建落地尘埃() -> void:
	if 落地尘埃开关:
		var dust = 落地尘埃.instantiate()
		node_2d_2.add_child(dust)
		dust.global_position.x = global_position.x
		dust.global_position.y = global_position.y + 7
