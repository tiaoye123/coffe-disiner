extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_over.connect(over)


func over() -> void:
	var show_tween = create_tween()
	show_tween.tween_property(self , "modulate:a" , 1.0 , 1.0)
	await show_tween.finished
	get_tree().change_scene_to_file("res://scenes/主菜单.tscn")
