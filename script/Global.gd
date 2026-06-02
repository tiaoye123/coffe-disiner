extends Node

#全局信号
#获取增益时的信号，buff_name用于传递玩家取得的buff种类
signal get_coffe_buff(buff_name : String)
signal enter_to_crasy()
signal enter_to_normal()
signal position_for_buff_ball(position : Vector2 , flip_h : bool)
signal 冲刺按键提示()
signal 第一房间开场动画完毕()
signal 取得含糖咖啡()
signal 玩家死亡转场()
signal 死亡转场结束()

#玩家位置
var player_position : Vector2

#控制玩家所有移动相关脚本是否生效变量
var player_can_move : bool = true

#咖啡计量条数值
var coffe_number_max : float = 34
var coffe_number : float:
	set(value):
		if coffe_number >= (coffe_number_max / 2) and value <= (coffe_number_max / 2):
			enter_to_crasy.emit()
		coffe_number = value
#疯狂计量条比值
var crasy_rate : float


func _ready() -> void:
	coffe_number = coffe_number_max * 0.8
	玩家死亡转场.connect(func()->void: coffe_number = 20)


func _physics_process(delta: float) -> void:
	coffe_number -= delta
	crasy_rate = coffe_number / (coffe_number_max / 2)
