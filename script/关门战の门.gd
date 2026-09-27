extends Node2D


func _ready() -> void:
	Global.玩家进入关门战场地.connect(static_up)
	Global.关门战结束.connect(static_down)


func static_up() -> void:
	var move_tween = get_tree().create_tween()
	move_tween.tween_property(self , "global_position:y" , self.global_position.y - 48 , 1.0)


func static_down() -> void:
	var move_tween = get_tree().create_tween()
	move_tween.tween_property(self , "global_position:y" , self.global_position.y + 48 , 1.0)
