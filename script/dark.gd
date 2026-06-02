extends Panel

var rate : float
@export var max_modulat : float = 1.5

func _physics_process(delta: float) -> void:
	rate = Global.crasy_rate
	if rate < 1 and rate > 0:
		modulate.a = max_modulat * (1 - rate)
	if rate > 1:
		modulate.a = 0
