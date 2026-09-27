extends Node2D

@onready var 左: TileMapLayer = $左
@onready var 右: TileMapLayer = $右
var move_tween : Tween



#玩家触碰到之后，桥梁伸缩而后自然合拢
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if move_tween and move_tween.is_running():
			print("1")
		else:
			move_tween = get_tree().create_tween()
			move_tween.tween_property(左 , "global_position:x" , 左.global_position.x - 16  , 0.2)
			move_tween.parallel().tween_property(右 , "global_position:x" , 右.global_position.x + 16  , 0.2)
			await move_tween.finished
			await get_tree().create_timer(0.8).timeout
			move_tween = get_tree().create_tween()
			move_tween.tween_property(左 , "global_position:x" , 左.global_position.x + 16  , 0.8)
			move_tween.parallel().tween_property(右 , "global_position:x" , 右.global_position.x - 16  , 0.8)
