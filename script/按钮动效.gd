extends Button

@export var shake_rate : float = 3.0
@export var scale_target : float = 1.05
@export var back_time : float = 0.2
@export var label : Label
var shake_tween : Tween
var label_tween : Tween
func _ready() -> void:
	await get_tree().process_frame
	pivot_offset = size/2.0
	resized.connect(func(): pivot_offset = size / 2.0)
	mouse_entered.connect(悬停动效)
	mouse_exited.connect(退出悬停)


func _physics_process(delta: float) -> void:
	pass


func 悬停动效() -> void:
	if label:
		label_out()
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()
	shake_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	shake_tween.tween_property(self , "scale:x" , scale_target , 0.2)
	shake_tween.parallel().tween_property(self , "scale:y" , scale_target , 0.35)
	shake_tween.parallel().tween_property(self , "rotation_degrees" , shake_rate * [-1.0 , 1.0].pick_random() , 0.1)
	shake_tween.parallel().tween_property(self , "rotation_degrees" , 0 , 0.1).set_delay(0.1)





func  label_out() -> void:
	if label_tween and label_tween.is_running():
		label_tween.kill()	
	var T_1 = (label.position.x - 10) / ((47 - 10) / 0.25)
	label_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	label_tween.tween_property(label , "position:x" , 10 , T_1)
	label_tween.parallel().tween_property(label , "scale:x" , 0.90 , 0.1).set_delay(T_1 * (0.15 / 0.25))
	label_tween.parallel().tween_property(label , "scale:y" , 1.10 , 0.1)
	label_tween.tween_property(label , "scale:x" , 1.0 , 0.1)
	label_tween.parallel().tween_property(label , "scale:y" , 1.0 , 0.1)
	await label_tween.finished



func 退出悬停() -> void:
	if label:
		label_back()
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()
		rotation_degrees = 0
	var T_x =  (scale.x - 1.0 ) / ((scale_target - 1) / 0.2)
	var T_y =  (scale.y - 1.0 ) / ((scale_target - 1) / 0.2)
	shake_tween = create_tween()
	shake_tween.tween_property(self , "scale:x" , 1.0 , T_y)
	shake_tween.parallel().tween_property(self , "scale:y" , 1.0 , T_y)
	shake_tween.parallel().tween_property(self , "rotation_degrees" , shake_rate * [-1.0 , 1.0].pick_random() , 0.1)
	shake_tween.parallel().tween_property(self , "rotation_degrees" , 0 , 0.1).set_delay(0.1)


func label_back() -> void:
	if label_tween and label_tween.is_running():
		label_tween.kill()
	var T_1 = (47 - label.position.x) / ((47 - 10) / 0.25)
	label_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	label_tween.tween_property(label , "scale:x" , 0.90 , 0.1)
	label_tween.parallel().tween_property(label , "scale:y" , 1.10 , 0.1)
	label_tween.tween_property(label , "scale:x" , 1.0 , 0.1)
	label_tween.parallel().tween_property(label , "scale:y" , 1.0 , 0.1)
	label_tween.parallel().tween_property(label , "position:x" , 47 , T_1).set_delay(0.05)




	await label_tween.finished
