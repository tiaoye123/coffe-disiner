extends Node2D

const 咖啡小恶魔 = preload("res://scenes/咖啡小恶魔.tscn")



func _ready() -> void:
	Global.第二房间开场演出开始.connect(spawn_evil)
	Global.玩家进入boss场地.connect(spawn_evil)


#生成小恶魔
func spawn_evil() -> void:
	var a = 咖啡小恶魔.instantiate()
	add_child(a)
