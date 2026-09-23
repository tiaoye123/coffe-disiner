extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var HP : int = 4:
	set(value):
		HP = value
		if HP == 0:
			delete_self()
@export var a : float = 40
var player : Node2D
@onready var 受伤动画: AnimationPlayer = $受伤动画
var velocity : Vector2 = Vector2(1 , 1)
signal self_dead()
var is_flip : float = 1
var on_hit : bool = false
var hit_v : Vector2
var stop : bool = false
var 受伤粒子池 : Array[GPUParticles2D] = []
const 受伤粒子 = preload("res://受伤粒子.tscn")
@onready var 漂浮动画: AnimationPlayer = $漂浮动画


func _ready() -> void:
	catch_player()
	Global.死亡转场结束.connect(delete_self)
	Global.玩家死亡转场.connect(func(): stop = true)
	for i in 6:
		var p = 受伤粒子.instantiate()
		add_child(p)
		受伤粒子池.append(p)


func _physics_process(delta: float) -> void:
	
	if not 受伤粒子池.is_empty():
		for p in 受伤粒子池:
			if sprite_2d:
				p.position = sprite_2d.position
	
	
	if player and sprite_2d and not stop:
		var speed : Vector2 = (player.global_position - global_position).normalized()
		#调整朝向
		velocity = velocity.move_toward(speed , 0.5)
		if speed.x > 0:
			sprite_2d.flip_h = true
		elif speed.x <0:
			sprite_2d.flip_h = false
		global_position += velocity * a * delta * is_flip


#寻找场景中的player节点
func catch_player() -> void:
	var player_group = get_tree().get_nodes_in_group("Player")
	for e in player_group:
		player = e


#按照先闪图片再删自己的方式删除（给粒子效果腾出时间）
func delete_self() -> void:
	if sprite_2d:
		self.remove_from_group("animy")
		self_dead.emit()
		sprite_2d.queue_free()
		await get_tree().create_timer(1.0).timeout
	queue_free()


#吃伤_播放吃伤动画和粒子效果
func hurt(冲击方向 : Vector2) -> void:
	HP -= 1
	if 受伤动画.is_playing():
		受伤动画.seek(0.15)
	受伤动画.play("受击动画_l")
	#受击按照碰撞方向发射粒子
	for p in 受伤粒子池:
		if not p.emitting:
			var a = p.process_material as ParticleProcessMaterial
			var c = 冲击方向.normalized()
			print(a.direction)
			p.emitting = true
			break
	
	#受到冲击
	velocity = velocity.move_toward(冲击方向 , 2.5)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.dead()
		delete_self()
