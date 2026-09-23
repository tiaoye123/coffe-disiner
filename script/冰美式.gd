extends Node2D

@onready var area_2d: Area2D = $Sprite2D/Area2D
@export var buff_name : String = "强化冲刺"


#依旧初始化
func _ready() -> void:
	area_2d.body_entered.connect(player_touch)


#依旧player碰到给player传参
func player_touch(body : Node2D) -> void:
	Global.get_coffe_buff.emit(buff_name)
	Global.coffe_number = Global.coffe_number_max
	queue_free()
