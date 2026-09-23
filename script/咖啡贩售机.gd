extends Node2D


const coffe = preload("res://scenes/coffe/拿铁.tscn")
@onready var 时间计量条: Sprite2D = $时间计量条

#检索子节点是否有咖啡用计数器d
var check_index : int = 0
#是否正在生成咖啡
var is_in_spawn : bool = false

#刚开始咖啡的生成
func _ready() -> void:
	var a = coffe.instantiate()
	add_child(a)
	a.global_position = Vector2(69.115 , -42.596)
	a.scale = Vector2(0.6 , 0.6)
	a.owner = self


func _physics_process(delta: float) -> void:
	
	#判断是否在生成咖啡以跳过
	if is_in_spawn:
		return
	
	#检索子节点下是否有咖啡
	check_index = 0
	for child in get_children():
		if child.is_in_group("coffe"):
			check_index += 1
	if check_index == 0:
		spawn()


#读进度条生成咖啡
func spawn() -> void:
	is_in_spawn = true
	时间计量条.visible = true
	时间计量条.frame = 0
	var spwan_tween = get_tree().create_tween()
	spwan_tween.tween_method(时间计量动画 , 0 , 32 , 4.0)
	await spwan_tween.finished
	var a = coffe.instantiate()
	add_child(a)
	a.global_position = Vector2(69.115 , -42.596)
	a.scale = Vector2(0.6 , 0.6)
	a.owner = self
	时间计量条.visible = false
	is_in_spawn = false


func 时间计量动画(value : int) -> void:
	时间计量条.frame = value
