extends Control

#对话放在这里
@export var dialogues01 : Dialogue_group
@export var dialogues02 : Dialogue_group
@export var dialogues03 : Dialogue_group
@export var dialogues04 : Dialogue_group
@export var dialogues05 : Dialogue_group
@export var dialogues06 : Dialogue_group

var witch_dialogues : Dialogue_group

@onready var 头像右: TextureRect = $HBoxContainer/头像右
@onready var 头像左: TextureRect = $HBoxContainer/头像左
@onready var the_name: Label = $HBoxContainer/对话框/MarginContainer/VBoxContainer/the_name
@onready var text: Label = $HBoxContainer/对话框/MarginContainer/VBoxContainer/text

var dialogue_index : int = 0
var typping_tween : Tween


func _ready() -> void:
	Global.第一房间开场动画完毕.connect(第一房间开场动画对话)
	Global.第二房间开场演出开始.connect(第二房间开场动画对话)
	Global.第二房间咖啡演出开始.connect(第二房间咖啡动画对话)


func 第一房间开场动画对话() -> void:
	visible = true
	witch_dialogues = dialogues01
	display_next_dialogue()


func 第二房间开场动画对话() -> void:
	visible = true
	witch_dialogues = dialogues02
	display_next_dialogue()


func 第二房间咖啡动画对话() -> void:
	await get_tree().create_timer(0.5).timeout
	visible = true
	witch_dialogues = dialogues03
	display_next_dialogue()


#对话UI显示时，暂停游戏
func _physics_process(delta: float) -> void:
	if visible == true:
		get_tree().paused = true
	else:
		get_tree().paused = false


#播放对话
func display_next_dialogue() -> void:
	
	if dialogue_index >= len(witch_dialogues.dialogue_group):
		visible = false
		witch_dialogues = null
		dialogue_index = 0
		return
	
	#解析出当前对话是哪一句
	var dialogue = witch_dialogues.dialogue_group[dialogue_index] as Dialogue
	the_name.text = dialogue.name
	
	#更改UI头像
	if dialogue.show_on_left:
		头像左.texture = null
		头像右.texture = dialogue.texture
	else:
		头像左.texture = dialogue.texture
		头像右.texture = null
	
	#打字机效果实现
	if typping_tween and typping_tween.is_running():
		typping_tween.kill()
		text.text = dialogue.text
		dialogue_index += 1
	else:
		text.text = ""
		typping_tween = create_tween()
		for a in dialogue.text:
			typping_tween.tween_callback(display_text.bind(a)).set_delay(0.05)								
		typping_tween.tween_callback(func(): dialogue_index += 1 )


#逐字加入对话
func display_text(a : String) -> void:
	text.text += a


#点击继续对话
func _on_对话框_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed(): 
		display_next_dialogue()
