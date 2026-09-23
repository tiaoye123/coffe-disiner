extends CharacterBody2D

var goal_position : Vector2
var speed : Vector2

const EVIL_DIALOGUE_FOR_BAD = preload("res://resource/Dialogue/Evil_dialogue_for_bad.tres")
const EVIL_DIALOGUE_FOR_GOOD_COFFE = preload("res://resource/Dialogue/Evil_dialogue_for_good_coffe.tres")
@onready var label: Label = $Sprite2D/Label

var 输出阻断 : int = 0

var show_tweem : Tween


func _ready() -> void:
	Global.get_coffe_buff.connect(evil_speak_good)
	Global.取得含糖咖啡.connect(evil_speak_bad)
	label.text = ""

	
	#玩家死亡后重置小恶魔位置
	Global.玩家死亡转场.connect(spawn)

	
	#等一秒生成小恶魔
	await get_tree().create_timer(0.01).timeout
	spawn()


func evil_speak_bad() -> void:
	#同下
	var i = randi_range(0 , (len(EVIL_DIALOGUE_FOR_BAD.dialogue_group) - 1))
	var whitch_dialogue = EVIL_DIALOGUE_FOR_BAD.dialogue_group[i]
	
	speak(whitch_dialogue)


func evil_speak_good(buff_name : String) -> void:
	#随机选取对话组中good咖啡对话传递给对话输出函数
	var i = randi_range(0 , (len(EVIL_DIALOGUE_FOR_GOOD_COFFE.dialogue_group) - 1))
	var whitch_dialogue = EVIL_DIALOGUE_FOR_GOOD_COFFE.dialogue_group[i]
	
	speak(whitch_dialogue)


#输出传入的对话
func speak(whitch_dialogue : Dialogue) -> void:
	#掠过过场动画中第一次捡到咖啡时触发的输出
	if 输出阻断 == 0:
		输出阻断 += 1
		return
	
	#打断当前进行中的对话
	if show_tweem and show_tweem.is_running():
		show_tweem.kill()
	#将当前对话输出
	label.text += whitch_dialogue.text
	var time : float = len(label.text) * 0.05
	label.visible_ratio = 0
	show_tweem = get_tree().create_tween()
	show_tweem.tween_property(label , "visible_ratio" , 1.0 , time)
	#结束后清空对话栏
	await show_tweem.finished
	await get_tree().create_timer(1.5).timeout
	label.text = ""


func _process(delta: float) -> void:
	#计算小恶魔移动的目标位置
	goal_position.x = Global.player_position.x - 20
	goal_position.y = Global.player_position.y - 20
	计算当前速度()
	
	velocity = speed * 1.5
	move_and_slide()


#重新生成小恶魔位置
func spawn() -> void:
	await get_tree().create_timer(0.2).timeout
	global_position.x = Global.player_position.x - 20
	global_position.y = Global.player_position.y - 20


func 计算当前速度() -> void:
	speed = (goal_position - global_position).limit_length(200)
	
