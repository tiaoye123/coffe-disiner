extends Area2D

const player_start_position : Vector2 = Vector2(1440 , -360)


#修改玩家第五房间
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.change_start_position(player_start_position)
