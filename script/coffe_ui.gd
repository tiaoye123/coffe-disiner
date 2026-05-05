extends ProgressBar

@onready var 颜色动画: AnimationPlayer = $"../颜色动画"

#UI内置的咖啡计量数变量
var coffe_number : float:
	set(coffe_value):
		coffe_number = coffe_value
		value = coffe_value
		if coffe_value >= 30:
			颜色动画.play("happy")
		elif coffe_value >= 10:
			颜色动画.play("normal")
		else:
			颜色动画.play("crasy")



func _ready() -> void:
	
	max_value = Global.coffe_number_max


func _physics_process(delta: float) -> void:
	
	coffe_number = Global.coffe_number
