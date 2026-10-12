extends Node2D


func _ready() -> void:
	Global.确认退出菜单.connect(self_show)


func self_show() -> void:
	visible = true



func _on_yes_pressed() -> void:
	get_tree().quit()


func _on_no_pressed() -> void:
	visible = false
