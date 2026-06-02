extends Control



func _ready() -> void:
	Global.冲刺按键提示.connect(show_self)


func show_self() -> void:
	var show_tweem = create_tween()
	show_tweem.set_ignore_time_scale(true)
	show_tweem.tween_property(self , "modulate:a" , 0.8 , 1)
