extends StaticBody2D

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var tile_map_layer: TileMapLayer = $TileMapLayer




func _ready() -> void:
	Global.死亡转场结束.connect(死亡重置)


#玩家踩上平台后播放破碎动画 
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		平台晃动()


func 平台晃动() -> void:
	var shake_tween = create_tween()
	shake_tween.tween_property(self , "position" , position + Vector2(0.16, 0) , 0.05 )
	shake_tween.tween_property(self , "position" , position + Vector2(-0.32 , 0) , 0.05 )
	shake_tween.tween_property(self , "position" , position + Vector2(0.32 , 0) , 0.05 )
	shake_tween.tween_property(self , "position" , position + Vector2(-0.32 , 0) , 0.05 )
	shake_tween.tween_property(self , "position" , position + Vector2(0.32 , 0) , 0.05 )
	shake_tween.tween_property(self , "position" , position + Vector2(-0.16, 0) , 0.05 )
	await shake_tween.finished
	平台破碎()


func 平台破碎() -> void:
	gpu_particles_2d.emitting = true
	tile_map_layer.visible = false
	area_2d.monitoring = false
	collision_shape_2d.disabled = true


#玩家死亡后重置平台
func 死亡重置() -> void:
	tile_map_layer.visible = true
	area_2d.monitoring = true
	collision_shape_2d.disabled = false
