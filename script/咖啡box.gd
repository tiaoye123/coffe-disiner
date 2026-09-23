extends Node2D


@export var coffe : PackedScene
var check : bool
var ready_to_spawn : bool


func _ready() -> void:
	Global.死亡转场结束.connect(spawn)


func _physics_process(delta: float) -> void:
	
	if ready_to_spawn:
		return
	#判断咖啡是否被玩家捡走
	check = false
	for i in get_children():
		if i.is_in_group("coffe"):
			check = true
	if not check:
		ready_to_spawn = true


#玩家死亡时生成咖啡
func spawn() -> void:
	if ready_to_spawn:
		var a = coffe.instantiate()
		add_child(a)
		ready_to_spawn = false
