extends Node2D

@export var enemy01 : PackedScene
var search_enemy : bool = false
var player_is_in : bool = false
var 刷怪组 : String = "0"
var enemy_index : int = 0
@export var 第一波enemy_01_position : Vector2
@export var 第二波enemy_01_position : Vector2
@export var 第二波enemy_02_position : Vector2
@export var 第三波enemy_01_position : Vector2
@export var 第三波enemy_02_position : Vector2
@export var 第三波enemy_03_position : Vector2
@export var 刷怪间隔 : float = 1.5
@onready var 第一波enemis : Array[Vector2] = [第一波enemy_01_position]
@onready var 第二波enemis : Array[Vector2] = [第二波enemy_01_position , 第二波enemy_02_position]
@onready var 第三波enemis : Array[Vector2] = [第三波enemy_01_position , 第三波enemy_02_position , 第三波enemy_03_position]

func _ready() -> void:
	Global.玩家进入关门战场地.connect(玩家进入)
	Global.死亡转场结束.connect(死亡重置)
	


func _physics_process(delta: float) -> void:
	if player_is_in and search_enemy:
		enemy_index = 0
		for a in get_children():
			if a.is_in_group("animy"):
				enemy_index += 1
		if enemy_index >= 1:
			return
		下一组刷怪()




func 死亡重置():
	刷怪组 = "0"
	第一波次刷怪()


func 玩家进入() -> void:
	player_is_in = true
	await get_tree().create_timer(刷怪间隔).timeout
	第一波次刷怪()


func 玩家离开() -> void:
	player_is_in = false


func 下一组刷怪() -> void:
	match 刷怪组:
		"第二组":
			第二波次刷怪()
		"第三组":
			第三波次刷怪()
		"通关":
			关门战通过()


func 第一波次刷怪() -> void:
	if player_is_in:
		search_enemy = false
		刷怪(第一波enemis)
		刷怪组 = "第二组"
		search_enemy = true


func 第二波次刷怪() -> void:
	search_enemy = false
	await get_tree().create_timer(刷怪间隔).timeout
	刷怪(第二波enemis)
	刷怪组 = "第三组"
	search_enemy = true

func 第三波次刷怪() -> void:
	search_enemy = false
	await get_tree().create_timer(刷怪间隔).timeout
	刷怪(第三波enemis)
	刷怪组 = "通关"
	search_enemy = true


func 关门战通过() -> void:
	Global.关门战结束.emit()


func 刷怪(a : Array) -> void:
	for e_position in a:
		var e = enemy01.instantiate()
		e.global_position = e_position
		add_child(e)
