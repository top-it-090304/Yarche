extends Node2D

@onready var ui: Control = $Control
@onready var timer: Timer = $Timer
@onready var music: AudioStreamPlayer = $Gameworld/AgressiveTheme2

func _ready():
	show_contols()
	get_tree().paused = true
	timer.wait_time = 1
	timer.one_shot = true
	timer.start()
	
func show_contols():
	ui.modulate = Color(1,1,1,1)
	ui.visible = true
	
func hide_ui():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(ui, "modulate", Color(1,1,1,0), 0.5)
	tween.tween_callback(unpause)
	
func unpause():
	get_tree().paused = false
	music.play()
	ui.process_mode = PROCESS_MODE_INHERIT
func _on_timer_timeout():
	hide_ui()
