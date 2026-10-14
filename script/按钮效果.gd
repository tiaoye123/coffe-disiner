extends Node2D

@onready var shadow: Node2D = $"../shadow"
@onready var 按钮效果: Node2D = $"."
@onready var 开始游戏加载: AudioStreamPlayer = $"../开始游戏加载"
@onready var 拿铁: Sprite2D = $"../shadow/拿铁"
@onready var 含糖: Sprite2D = $"../shadow/含糖"
@onready var 美式: Sprite2D = $"../shadow/美式"
const MAIN = preload("res://scenes/Main.tscn")




func _on_退出_pressed() -> void:
	Global.确认退出菜单.emit()
	Global.按钮音效.emit()


func _on_开始_button_down() -> void:
	Global.按钮音效.emit()
	var shadow_tween = create_tween().set_ease(Tween.EASE_OUT)
	shadow_tween.tween_property(shadow , "scale" , Vector2(1 , 1) , 0.08)
	await shadow_tween.finished
	await get_tree().create_timer(0.5).timeout
	开始游戏加载.play()
	var scale_tween = create_tween()
	scale_tween.tween_property(拿铁 , "scale" , Vector2(0.5 , 0.5) , 0.55)
	scale_tween.tween_property(含糖 , "scale" , Vector2(0.5 , 0.5) , 0.55)
	scale_tween.tween_property(美式 , "scale" , Vector2(0.5 , 0.5) , 0.55)
	await scale_tween.finished
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_packed(MAIN)


func _on_设置_pressed() -> void:
	Global.按钮音效.emit()
	Global.设置菜单.emit()
