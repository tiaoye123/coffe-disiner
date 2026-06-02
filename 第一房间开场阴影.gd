extends ColorRect

@onready var shader_mat = material as ShaderMaterial

#遮罩中心点
var center_position : Vector2 = Vector2(56 , 105)

func _ready() -> void:
	#设置目标半径大小
	#创建补间动画平滑调整colorect着色器着色半径
	first_animation()


#后续打算把开场动画做成两段，先预留一下函数以后再说
func first_animation() -> void:
	Global.player_can_move = false
	var zoom_tween = create_tween()
	zoom_tween.tween_method(set_radius , 0.0 , 0.2 , 0.35)
	zoom_tween.tween_method(set_radius , 0.2 , 0.2 , 0.05)
	await zoom_tween.finished
	second_animation()


func second_animation() -> void:
	var zoom_tween = create_tween()
	zoom_tween.tween_method(set_radius , 0.2 , 0.17 , 0.1)
	zoom_tween.tween_method(set_radius , 0.17 , 2.0 , 1)
	await zoom_tween.finished
	Global.第一房间开场动画完毕.emit()
	Global.player_can_move = true



#修改着色半径
func set_radius(value) -> void:
	shader_mat.set_shader_parameter("radius" , value)
	shader_mat.set_shader_parameter("center" , Vector2(0.163 , 0.90))


#开场阴影动画结束
func animated_over() -> void:
	Global.第一房间开场动画完毕.emit()
