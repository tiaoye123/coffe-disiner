extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var 上红: PointLight2D = $上/红
@onready var 上绿: PointLight2D = $上/绿
@onready var 中红: PointLight2D = $中/红
@onready var 中绿: PointLight2D = $中/绿
@onready var 下红: PointLight2D = $下/红
@onready var 下绿: PointLight2D = $下/绿
@onready var 开灯: AudioStreamPlayer2D = $开灯
@onready var 结束: AudioStreamPlayer2D = $结束






func _ready() -> void:
	Global.第一波结束.connect(一灯)
	Global.第二波结束.connect(二灯)
	Global.关门战结束.connect(三灯)
	Global.死亡转场结束.connect(重置)


func 重置() -> void:
	sprite_2d.frame = 0
	上红.visible = true
	上绿.visible = false
	中红.visible = true
	中绿.visible = false
	下红.visible = true
	下绿.visible = false


func 一灯() -> void:
	开灯.play()
	sprite_2d.frame = 1
	下红.visible = false
	下绿.visible = true


func 二灯() -> void:
	开灯.play()
	sprite_2d.frame = 2
	中红.visible = false
	中绿.visible = true

func 三灯() -> void:
	开灯.play()
	sprite_2d.frame = 3
	上红.visible = false
	上绿.visible = true
	await get_tree().create_timer(0.95).timeout
	结束.play()
