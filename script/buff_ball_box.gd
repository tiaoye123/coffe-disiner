extends Node2D

var first_buff_position : Vector2
var Acceleration : float = 100
var speed : Vector2 
@onready var sprite_2d: Sprite2D = $Sprite2D
const DOUBLE_JUMP_BUFF_BALL = preload("res://scenes/coffe_buff/double_jump_buff_ball.tscn")
#用以存放当前角色拥有的buff球的容器
var buff_array : Array[Node2D]
var spawn_position : Vector2


func _ready() -> void:
	#接受玩家发送的位置信息
	Global.position_for_buff_ball.connect(check_position)
	Global.get_coffe_buff.connect(enter_buff_ball)
	Global.enter_to_normal.connect(delete_buff_ball)

#依照玩家获得的buff向数组中添入buff球
func enter_buff_ball(buff_name : String) -> void:
	if buff_name == "二段跳":
		var a = DOUBLE_JUMP_BUFF_BALL.instantiate()
		add_child(a)
		buff_array.append(a)
		a.global_position = spawn_position


func delete_buff_ball() -> void:
	for i in buff_array.size():
		buff_array[i].queue_free()
	buff_array.clear()


#利用玩家位置计算出咖啡球的几个终点位置
func check_position(player_position : Vector2 , is_flip : bool) -> void:
	#所有buff球的生成位置
	spawn_position.x = player_position.x - 10
	spawn_position.y = player_position.y - 10
	
	first_buff_position.y = player_position.y - 8
	if is_flip == false:
		first_buff_position.x = player_position.x -9
	else:
		first_buff_position.x = player_position.x +8
		
	buff_ball_move()


#用参数让特定buff球移动
func buff_ball_move() -> void:
	for i in buff_array.size():
		if i == 0 :
			speed = change_buff_ball_speed(buff_array[i].global_position, first_buff_position)
			speed.y += 1.5
			buff_array[i].global_position += speed * get_process_delta_time()


#计算buff球速度
func change_buff_ball_speed(the_position : Vector2 , buff_position : Vector2) -> Vector2:
	var face = buff_ball_face(the_position , buff_position)
	if face.length() >= 1: 
		speed += 2  * face 
		speed = speed.limit_length(100)
	else:
		speed = Vector2.ZERO
	return speed


#计算buff球所在位置到目标位置的单位向量（方向）
func buff_ball_face(now_position : Vector2 ,goal_position : Vector2) -> Vector2:
	var the_face : Vector2 = (goal_position - now_position)
	return the_face
