extends Node2D

@export var start_speed : float = 15
@export var start_ahead : Vector2
@export var slide_speed : Vector2
@export var attack_speed : float = 100
var velocity : Vector2
var target : Node2D
#enemy距离比较用变量
var ahead : float = 1000000000000000000
var speed_a : float = 1.0
@onready var 弹幕: Sprite2D = $弹幕
var slide_over : bool = false

var wait_time : float = 0


func _ready() -> void:
	初始滑动()


func _physics_process(delta: float) -> void:
	#如果索敌成功，开始追踪。失败则继续滑动
	if target:
		var T = target.sprite_2d
		#目标方向向量
		var a = (T.global_position - global_position).normalized()
		velocity = a * 150
		global_position += velocity * delta 
	else:
		global_position += velocity * delta 

#根据生成时给出的数据滑动1.0s
func 初始滑动() -> void:
	slide_speed = start_speed * start_ahead
	velocity = slide_speed
	await get_tree().create_timer(wait_time).timeout
	start_catch_animy()
	slide_over = true


#开始索敌
func start_catch_animy() -> void:
	target = null
	var enemys = get_tree().get_nodes_in_group("animy")
	#计算哪个敌人距离子弹最近后将其赋值给target变量
	for enemy in enemys:
		if not is_instance_valid(enemy):
			continue
		if global_position.distance_squared_to(enemy.global_position) < ahead:
			target = enemy
			ahead = global_position.distance_squared_to(enemy.global_position)
	if target:
		target.self_dead.connect(start_catch_animy)


func _on_area_2d_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent().get_parent()
	if enemy.is_in_group("animy"):
		var a = (enemy.global_position - global_position).normalized()
		enemy.hurt(a)
		queue_free()
