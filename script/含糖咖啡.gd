extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.coffe_number -= 10
		body.增益消除()
		Global.取得含糖咖啡.emit()
		queue_free()
