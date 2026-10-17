extends Node2D

@onready var canvas_modulate: CanvasModulate = $"../光照相关/CanvasModulate"

@onready var boss: Node2D = $"../boss"
@export var 中心 := Vector2.ZERO   # 相对父节点的椭圆圆心
@export var 半径a := 30       # 横向半径
@export var 半径b := 15        # 纵向半径
@export var 周期 := 3.0           # 转一圈要几秒
@export var 顺时针 := false

var t := 0.0

func _ready() -> void:
	Global.玩家进入boss场地.connect(delete)


func delete() -> void:
	canvas_modulate.color = Color.BLACK
	await get_tree().create_timer(3.0).timeout
	Global.game_over.emit()
	queue_free()
	


func _process(delta: float) -> void:
	t += delta / 周期 * TAU * (-1.0 if 顺时针 else 1.0)
	boss.global_position = global_position + Vector2(半径a * cos(t), 半径b * sin(t))
	
