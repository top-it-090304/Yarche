
extends Control

@onready var pump = $pump_anchor/inside_anchor/Pump
@onready var manometr = $manometr_anchor/inside_anchor/Manometr
@onready var game_timer = $GameTimer
@onready var pump_sound = $PumpSound
@onready var music = $Music
@onready var hiss_sound = $HissSound
@onready var wheel = $wheel_anchor/inside_anchor/Wheel

var current_pressure
var game_active = false
var hiss_playing = false

@export var timer_time: float = 10
@export var passive_leak_rate: float = 0.2
signal win
signal lose

func _ready():
	show_tutorial()
	get_tree().paused = true
	game_timer.wait_time = timer_time
	game_timer.one_shot = true
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()
	

	current_pressure = 0.0
	manometr.update_strelka(current_pressure)
	pump.pump_stroke.connect(_on_pump_stroke)
	
	if hiss_sound:
		hiss_sound.finished.connect(_on_hiss_finished)

func show_tutorial():
	var tutorial = preload("res://scenes/levels/PumpGame/pump_tutorial.tscn").instantiate()
	add_child(tutorial)
	tutorial.tutorial_finished.connect(_start_game)

func _start_game():
	get_tree().paused = false
	game_active = true
	game_timer.start()

func _on_hiss_finished():
	if hiss_playing and game_active and current_pressure > 0:
		hiss_sound.play()

func _process(delta):
	if not game_active:
		return
	release_pressure(delta * passive_leak_rate)

func _on_pump_stroke(amount: float):
	if not game_active:
		return
	encrease_manometr_value(amount)

func add_pressure(amount):
	encrease_manometr_value(amount)

func encrease_manometr_value(amount):
	current_pressure = manometr.encrease_manometr_value(amount)
	wheel.update_frame(current_pressure)
	
	if pump_sound and amount > 0:
		pump_sound.pitch_scale = 0.9 + randf() * 0.2
		pump_sound.play()
		
		stop_hiss_sound()
	
	if current_pressure >= manometr.max_pressure:
		game_over()

func release_pressure(amount):
	if not game_active:
		return
	
	current_pressure = manometr.decrease_manometr_value(amount)
	wheel.update_frame(current_pressure)
	
	if current_pressure > 0.1:
		start_hiss_sound()
	else:
		stop_hiss_sound()

func start_hiss_sound():
	if not hiss_playing and hiss_sound and game_active:
		hiss_sound.play()
		hiss_playing = true

func stop_hiss_sound():
	if hiss_sound and hiss_playing:
		hiss_sound.stop()
		hiss_playing = false

func _on_game_timer_timeout():
	if not game_active:
		return
	stop_hiss_sound()
	music.stop()
	
	if current_pressure >= 2.0 and current_pressure <= 2.6:
		win_game()
	elif current_pressure > 2.6:
		game_over()
	else:
		game_over()

func game_over():
	game_active = false
	stop_hiss_sound()
	lose.emit()

func win_game():
	game_active = false
	stop_hiss_sound()
	win.emit()
