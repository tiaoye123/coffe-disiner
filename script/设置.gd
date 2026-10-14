extends Node2D


func _ready() -> void:
	Global.设置菜单.connect(choose)

var scale_tween : Tween


func choose() -> void:
	if scale_tween and scale_tween.is_running():
		scale_tween.kill()
	if visible:
		self_hide()
	else:
		self_show()


func self_hide() -> void:
	scale_tween = create_tween().set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(self , "scale" , Vector2(0 , 0) , 0.04)
	await scale_tween.finished
	visible = false


func self_show() -> void:
	visible = true
	scale_tween = create_tween().set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(self , "scale" , Vector2(1.2 , 1.2) , 0.04)
	await scale_tween.finished
