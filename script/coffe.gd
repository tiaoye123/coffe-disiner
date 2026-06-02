extends Node2D

@onready var area_2d: Area2D = $Sprite2D/Area2D
@onready var 漂浮动画: AnimationPlayer = $漂浮动画
@export var buff_name : String = "二段跳"

func _ready() -> void:
	area_2d.body_entered.connect(player_touch)
	漂浮动画.play("咖啡漂浮")




#玩家碰到咖啡
func player_touch(body : Node2D)-> void:
	Global.get_coffe_buff.emit(buff_name)
	Global.coffe_number = Global.coffe_number_max
	queue_free()
