extends TextureRect




func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	set_pivot_offset(size / 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position() - size/2
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		rotation = deg_to_rad(-8)
	else:
		rotation = 0
