extends Node2D

@onready var ui: Control = $TapGameControl
@onready var timer: Timer = $Timer
@onready var music: AudioStreamPlayer = $Gameworld/AgressiveTheme2
@onready var win_screen: Control = $UI/win
@onready var computer_enemy: CharacterBody2D = $Gameworld/computer_enemy
@onready var lose_screen: Control = $UI/Lose

@export var timer_time = 1
signal end

func _ready():
	show_controls() 
	get_tree().paused = true
	
	computer_enemy.hit.connect(_show_lose_screen)
	
	timer.wait_time = 1
	timer.one_shot = true
	timer.timeout.connect(_on_controls_timeout)
	timer.start()
	
func show_controls():
	ui.modulate = Color(1,1,1,1)
	ui.visible = true
	win_screen.visible = false
	
func hide_ui():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(ui, "modulate", Color(1,1,1,0), 0.5)
	tween.tween_callback(start_game)
	
func start_game():
	get_tree().paused = false
	music.play()
	ui.process_mode = PROCESS_MODE_INHERIT
	timer.process_mode = PROCESS_MODE_INHERIT
	timer.timeout.disconnect(_on_controls_timeout)
	timer.timeout.connect(_show_win_screen)

	timer.wait_time = timer_time
	timer.start()

func _on_controls_timeout():
	hide_ui()
	
func _show_win_screen():
	print("Победа!")  # добавим для отладки
	get_tree().paused = true
	
	win_screen.visible = true
	win_screen.modulate = Color(1,1,1,0)
	
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(win_screen, "modulate", Color(1,1,1,1), 0.5)
	tween.tween_callback(_end_game)

func _show_lose_screen():
	get_tree().paused = true
	
	lose_screen.visible = true
	lose_screen.modulate = Color(1,1,1,0)
	
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(lose_screen, "modulate", Color(1,1,1,1), 0.5)
	tween.tween_callback(_end_game)
	
func _end_game():
	end.emit()
