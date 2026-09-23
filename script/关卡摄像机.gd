extends Camera2D

#相机摇晃
@export var shake_time : float = 0.05
@export var shake_await_time_max : float = 1
var shake_await_time : float
@export var the_rate : float = 1
var start_shake : bool = false
#每个房间的相机设定和相关参数（一个分的类）
#默认相机限制
const 默认limit_left : float = -1000000000
const 默认limit_top : float = -1000000000
const 默认limit_right : float = 100000000
const 默认limit_button : float = 100000000
#判定相机是否需要跟随角色
var player_follow : bool = false
#第一房间
@onready var 切房判定01: Area2D = $"../切房判定组/切房判定01"
const 第一房间专用空气墙 = preload("res://scenes/第一房间专用空气墙.tscn")
const first_room : Vector2 = Vector2(142 , 48)
#第二房间
const second_room : Vector2 = Vector2(142 , -100)
@onready var 切房判定02: Area2D = $"../切房判定组/切房判定02"
#第三房间
var player_is_in_third_room : bool = false
@onready var 第三房间area_2d: Area2D = $"../摄像机脚本判定组/组01——第三房间/Area2D"
const player_start_position_in_third_room = Vector2(295 , -104)
const third_room : Vector2 = Vector2(406 , -100)
#第三房间相机限制
const 第三房间limit_left : float = 278
const 第三房间limit_top : float = -172
const 第三房间limit_right : float = 100000
const 第三房间limit_button : float = -28
#第四房间
@onready var 切房判定03: Area2D = $"../切房判定组/切房判定03"
const forth_room : Vector2 = Vector2(1099 , -100)
const player_start_position_in_forth_room = Vector2(993 , -54)
const 第四房间limit_left : float = 971
const 第四房间limit_top : float = -430
const 第四房间limit_right : float = 1227
const 第四房间limit_button : float = -28
const 第三第四房间之间空气墙 = preload("res://scenes/第三第四房间之间空气墙.tscn")
#第五房间
@onready var 切房判定04: Area2D = $"../切房判定组/切房判定04"
const 第五房间limit_left : float = 1235
const 第五房间limit_top : float = -430
const 第五房间limit_right : float = 1491
const 第五房间limit_button : float = -28
const 第四第五房间之间空气墙 = preload("res://scenes/第四第五房间之间空气墙.tscn")
const player_start_position_in_fifth_room : Vector2 = Vector2(1440 , -360)


func _ready() -> void:
	相机抖动()
	global_position = first_room
	await get_tree().create_timer(0.05).timeout
	limit_smoothed = true
	Global.玩家死亡转场.connect(死亡重置判定)


func _physics_process(delta: float) -> void:
	the_rate = Global.crasy_rate
	if the_rate <= 1:
		start_shake = true
		shake_await_time = shake_await_time_max * the_rate 
		shake_await_time = clamp(shake_await_time , 0.1 , 2)
	else:
		start_shake = false
		shake_await_time = shake_await_time_max


func _process(delta: float) -> void:
	#根据需求让相机跟随角色
	if player_follow:
		position_smoothing_speed = 2
		global_position = Global.player_position
	else:
		position_smoothing_speed = 5


func 相机抖动() -> void:
	if start_shake:
		var shake_tween = create_tween()
		shake_tween.tween_property(self , "offset" , Vector2(randi_range(-2 , -1) ,0) , shake_time)
		shake_tween.tween_property(self , "offset" , Vector2(randi_range( 1 ,  2) ,0) , shake_time)
		shake_tween.tween_property(self , "offset" , Vector2.ZERO , shake_time)
		await shake_tween.finished
		await  get_tree().create_timer(shake_await_time).timeout
		相机抖动()
	else:
		await  get_tree().create_timer(0.1).timeout
		相机抖动()


#切换相机限制
func change_camera_limit(left : float , right : float , up : float , down : float) -> void:
	limit_left = left
	limit_right = right
	limit_top = up
	limit_bottom = down



#01-02房间切换
func _on_切房判定01_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		global_position = second_room
		切房判定01.queue_free()
		#稍作等待，让摄像机动一会再触发玩家的切换房间函数（说实话写的不是很好，再说
		Global.player_can_move = false
		await get_tree().create_timer(1.3).timeout
		Global.player_can_move = true
		var a = 第一房间专用空气墙.instantiate()
		Global.第二房间开场演出准备.emit()
		get_parent().add_child(a)


#02-03房间切换
func _on_切房判定02_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.change_start_position(player_start_position_in_third_room)
		global_position = third_room
		切房判定02.queue_free()
		player_is_in_third_room = true
		Global.player_can_move = false
		await get_tree().create_timer(1.0).timeout
		Global.player_can_move = true
		change_camera_limit(第三房间limit_left , 第三房间limit_right , 第三房间limit_top , 第三房间limit_button)
		player_follow = true


#以下仨用来控制第三房间摄像机经行特殊移动(好让玩家看清关卡关键部分全貌
func 第三方房间特殊区域进入(body: Node2D) -> void:
	if body.is_in_group("Player"):
		global_position.x = 846
		player_follow = false
		第三房间area_2d.monitoring = false


#03-04
func _on_切房判定03_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		切房判定03.queue_free()
		body.change_start_position(player_start_position_in_forth_room)
		change_camera_limit(第四房间limit_left , 第四房间limit_right , 第四房间limit_top , 第四房间limit_button)
		player_follow = false
		var a = 第三第四房间之间空气墙.instantiate()
		get_parent().add_child(a)
		Global.player_can_move = false
		await get_tree().create_timer(1.0).timeout
		Global.player_can_move = true
		player_follow = true
	


#04-05
func _on_切房判定04_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		切房判定04.queue_free()
		var a = 第四第五房间之间空气墙.instantiate()
		body.change_start_position(player_start_position_in_fifth_room)
		get_parent().add_child(a)
		change_camera_limit(第五房间limit_left , 第五房间limit_right , 第五房间limit_top , 第五房间limit_button)
		Global.player_can_move = false
		await get_tree().create_timer(1.0).timeout
		Global.player_can_move = true
		player_follow = true


func 死亡重置判定() -> void:
	if player_is_in_third_room:
		player_follow = true
		第三房间area_2d.monitoring = true
