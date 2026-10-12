extends ColorRect

@onready var 时间: Label = $任务栏时间组件/时间
@onready var 日期: Label = $任务栏时间组件/日期

func _physics_process(delta: float) -> void:
	var T := Time.get_datetime_dict_from_system()
	时间.text = "%02d:%02d" % [T["hour"], T["minute"]]
	日期.text = "%02d/%02d/%02d" % [T["year"] , T["month"] , T["day"]]
