extends Node2D

@onready var ui: Control = $Control
@onready var timer: Timer = $Timer

func _ready():
	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	show_contols()
	get_tree().paused = true
	
	timer.wait_time = 2
	timer.one_shot = true
	timer.start()
	
func show_contols():
	ui.modulate = Color(1,1,1,1)
	ui.visible = true
	
func hide_ui():
	ui.modulate = Color(1,1,1,0)
	ui.visible = false
	get_tree().paused = false
		
func _on_timer_timeout():
	print("fdjghkjfdg")
	hide_ui()
