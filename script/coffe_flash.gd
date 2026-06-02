extends ColorRect

var fade_tween : Tween

func _ready() -> void:
	Global.get_coffe_buff.connect(flash)


#获得咖啡时的屏幕闪光
func flash(buff_name : String) -> void:
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()
	fade_tween = create_tween()
	modulate.a = 1
	fade_tween.tween_property(self , "modulate:a" , 0.7 , 0.1)
	fade_tween.tween_property(self , "modulate:a" , 0 , 0.3)
