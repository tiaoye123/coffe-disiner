extends Node2D

@onready var panel: Panel = $Panel


func _ready() -> void:
	Global.确认退出菜单.connect(self_show)


func self_show() -> void:
	visible = true
	var scale_tween = create_tween().set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(self , "scale" , Vector2(1 , 1) , 0.04)
	await scale_tween.finished
	panel.visible = true



func _on_yes_pressed() -> void:
	Global.按钮音效.emit()
	await get_tree().create_timer(0.25).timeout
	get_tree().quit()


func _on_no_pressed() -> void:
	Global.按钮音效.emit()
	visible = false
	panel.visible = false
	scale = Vector2(0 , 0)
