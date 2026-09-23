extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.第二房间咖啡演出开始.emit()
		queue_free()
