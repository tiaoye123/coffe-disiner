extends Node2D
@onready var color_rect_2: ColorRect = $"../ColorRect2"
@onready var color_rect_3: ColorRect = $"../ColorRect3"



func _on_退出_pressed() -> void:
	get_tree().quit()


func _on_开始_button_down() -> void:
	var shadow_tween = create_tween()
	shadow_tween.tween_property(color_rect_2 , "position:y" , 0 , 0.8)
	shadow_tween.parallel().tween_property(color_rect_3 , "position:y" , 0 , 0.8)
	await shadow_tween.finished
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
