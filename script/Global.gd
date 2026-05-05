extends Node

#全局信号
signal get_coffe_buff(buff_name : String)
signal enter_to_crasy()
signal enter_to_normal()
signal position_for_buff_ball(position : Vector2 , flip_h : bool)

#咖啡计量条数值
var coffe_number_max : float = 40
var coffe_number : float:
	set(value):
		if coffe_number >= 30 and value <= 30:
			enter_to_normal.emit()
		if coffe_number >= 10 and value <= 10:
			enter_to_crasy.emit()
		coffe_number = value


func _ready() -> void:
	coffe_number = coffe_number_max / 2


func _physics_process(delta: float) -> void:
	coffe_number -= delta
