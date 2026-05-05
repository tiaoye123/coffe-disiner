extends Sprite2D




func instiantial(p_frame : int , p_position : Vector2 , p_flip_h : bool) -> void:
	self.frame = p_frame
	self.flip_h = p_flip_h
	global_position = p_position
	var fade_tween = create_tween()
	fade_tween.tween_property(self , "modulate:a" , 0.0 , 0.2)
	await fade_tween.finished
	queue_free()
