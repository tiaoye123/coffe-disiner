extends Control

const need_buff_name : String = "强化冲刺"
@export var 起始位置 : Vector2
@export var 展示位置 : Vector2
@export var 最终位置 : Vector2
@export var 抖动幅度 : float = 2
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var 时间计量条: Sprite2D = $Sprite2D/时间计量条


func _ready() -> void:
	Global.get_coffe_buff.connect(便利贴展示)


#便利贴展示序列动画
func 便利贴展示(buff_name : String) -> void:
	if buff_name == need_buff_name:
		await get_tree().create_timer(0.1).timeout
		sprite_2d.global_position = 起始位置
		var move_tween = create_tween()
		move_tween.tween_property(sprite_2d , "global_position" , Vector2(展示位置.x , 展示位置.y + 抖动幅度) , 0.4)
		move_tween.tween_property(sprite_2d , "global_position" , Vector2(展示位置.x , 展示位置.y) , 0.1).set_delay(0.05)
		#利用补间动画实现的计时可视化
		move_tween.tween_method(时间计量条动画 , 0 , 32 , 4.0)
		move_tween.parallel().tween_property(sprite_2d , "global_position" , Vector2(展示位置.x - 抖动幅度 , 展示位置.y) , 0.25).set_delay(4.0)
		move_tween.tween_property(sprite_2d , "global_position" , 最终位置 , 0.25).set_delay(0.1)
		await move_tween.finished
		queue_free()


#时间计量条随时间动画
func 时间计量条动画(value : int) -> void:
	时间计量条.frame = value
