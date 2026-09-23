extends Node2D

@export var 爆裂弹幕 : PackedScene

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.get_coffe_buff.emit("1")
		释放爆裂弹幕()


#初始化分散释放弹幕
func 释放爆裂弹幕() -> void:
	var a = 爆裂弹幕.instantiate()
	a.start_ahead = Vector2(1.0 , 1.0)
	a.global_position = global_position
	a.wait_time = 0.6
	get_parent().add_child(a)
	a = 爆裂弹幕.instantiate()
	a.start_ahead = Vector2(-1.0,1.0)
	a.global_position = global_position
	a.wait_time = 0.7
	get_parent().add_child(a)
	a = 爆裂弹幕.instantiate()
	a.start_ahead = Vector2(-1.0,-1.0)
	a.global_position = global_position
	a.wait_time = 0.8
	get_parent().add_child(a)
	a = 爆裂弹幕.instantiate()
	a.start_ahead = Vector2(1.0,-1.0)
	a.global_position = global_position
	a.wait_time = 0.9
	get_parent().add_child(a)
	a = 爆裂弹幕.instantiate()
	a.start_ahead = Vector2(1.414 ,0)
	a.global_position = global_position
	a.wait_time = 1.0
	get_parent().add_child(a)
	a = 爆裂弹幕.instantiate()
	a.start_ahead = Vector2(-1.414 ,0)
	a.global_position = global_position
	a.wait_time = 1.1
	get_parent().add_child(a)
	queue_free()
