@tool
extends Line2D


@export var 初始位置 : Vector2
@export var high : float = 50
@export var a : Vector2 
@export var clamp : float = 55
@onready var boss : Node2D = $".."
var current_end := Vector2.ZERO
var busy : bool = false
var 基准坐标 : Vector2
var 迈腿位置 : Vector2
var b : Vector2
var tw : Tween




func _ready() -> void:
	queue_redraw()


func _process(delta: float) -> void:
	b = get_point_position(3)
	if 基准坐标.distance_to(迈腿位置) > clamp:
		if tw and tw.is_running():
			pass
		else:
			tw = create_tween()
			tw.tween_method(func(v): current_end = v, b , 迈腿位置, 0.1)
			tw.finished.connect(func(): busy = false)
	reload()
	queue_redraw()
	pass


#画出点
func _draw() -> void:
	var offset := to_local(boss.global_position)
	基准坐标 = 初始位置 + offset
	迈腿位置 = (基准坐标 * 2) - b
	draw_circle(基准坐标 , 4.0 , Color.RED)
	draw_circle(迈腿位置 , 4.0, Color.GREEN)
	pass


func reload() -> void:
	var start := to_local(boss.global_position)
	var point := PackedVector2Array()
	for i in 4:
		var t := float(i) / 3.0
		var p := start.lerp(current_end , t)
		p.y -= 4.0 * high * t * (1.0 - t)
		point.append(p)
	points = point
