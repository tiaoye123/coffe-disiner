extends Node2D

@export var A_coffe : PackedScene
var ready_to_spwan : bool = false

func _ready() -> void:
	Global.死亡转场结束.connect(spawn)



func _physics_process(delta: float) -> void:
	if ready_to_spwan:
		return
	var check : bool = false
	for i in get_children():
		if i.is_in_group("coffe"):
			check = true
	if not check:
		ready_to_spwan = true


#生成咖啡
func spawn() -> void:
	if ready_to_spwan:
		var a = A_coffe.instantiate()
		add_child(a)
		ready_to_spwan = false
