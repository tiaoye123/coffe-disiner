extends GPUParticles2D

func _ready() -> void:
	释放粒子()
	自删计时()


func 释放粒子():
	emitting = true
	await get_tree().create_timer(0.1).timeout
	emitting = false


func 自删计时():
	await get_tree().create_timer(1.2).timeout
	queue_free()
