extends Polygon2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer





func _ready() -> void:
	Global.玩家死亡转场.connect(死亡转场启动)


#以下函数和玩家死亡后的黑屏转场有关，做的不是很好后面有功夫重构一下
func 死亡转场启动() -> void:
	animation_player.play("死亡转场")
	await get_tree().create_timer(0.4).timeout
	Global.死亡转场结束.emit()
