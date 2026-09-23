extends PointLight2D

@export var min : float
@export var max : float


func _ready() -> void:
	energy = max
	闪烁()


func 闪烁():
	var flash_tween = create_tween()
	flash_tween.tween_property(self , "energy" , min , 1.0)
	flash_tween.tween_property(self , "energy" , max , 1.0)
	await flash_tween.finished
	闪烁()
