extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var 气泡漂移粒子: GPUParticles2D = $气泡漂移粒子
@onready var 气泡消除粒子: GPUParticles2D = $气泡消除粒子


func _ready() -> void:
	var scale_tween = get_tree().create_tween()
	scale_tween.tween_property(sprite_2d , "scale:y" , 1.0 , 0.1)


func delete() -> void:
	var scale_tween = get_tree().create_tween()
	scale_tween.tween_property(sprite_2d , "scale:y" , 0.0 , 0.1)
	scale_tween.parallel().tween_property(sprite_2d , "modulate:rgb" , Vector3(1.0,1.0,1.0) , 0.1)
	await scale_tween.finished
	气泡漂移粒子.emitting = false
	气泡消除粒子.emitting = true
	await get_tree().create_timer(1.5).timeout
	queue_free()
