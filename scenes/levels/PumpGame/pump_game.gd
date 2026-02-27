extends Node2D

@onready var pump = $Pump
@onready var manometr = $Manometr
@onready var timer_bar = $"../TimerBar"
@onready var game_timer = $GameTimer
@onready var pump_sound = $PumpSound
@onready var hiss_sound = $HissSound

var current_pressure
var game_active = false
var game_time = 15.0

var touching_pump = false
var pump_touch_index = -1
var hiss_playing = false

func _ready():
	show_tutorial()
	game_timer.wait_time = game_time
	game_timer.one_shot = true
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()
	
	timer_bar.max_value = game_time
	timer_bar.value = game_time

	current_pressure = 0.0
	manometr.update_strelka(current_pressure)
	
	if hiss_sound:
		hiss_sound.finished.connect(_on_hiss_finished)

func show_tutorial():
	var tutorial = preload("res://scenes/levels/PumpGame/pump_tutorial.tscn").instantiate()
	add_child(tutorial)
	tutorial.tutorial_finished.connect(_start_game)

func _start_game():
	game_active = true
	game_timer.start()

func _on_hiss_finished():
	if hiss_playing and game_active and current_pressure > 0:
		hiss_sound.play()

func _process(delta):
	if not game_active:
		return
	if game_active:
		timer_bar.value = game_timer.time_left

func _input(event):
	if not game_active:
		return
	
	if event is InputEventScreenTouch:
		handle_touch_event(event)
	
	elif event is InputEventScreenDrag and touching_pump and event.index == pump_touch_index:
		handle_drag_event(event)

func handle_touch_event(event):
	if event.pressed:
		if is_point_on_pump(event.position):
			touching_pump = true
			pump_touch_index = event.index
			pump.start_touch(event.position)
	else:
		if event.index == pump_touch_index:
			touching_pump = false
			pump_touch_index = -1
			pump.end_touch()

func handle_drag_event(event: InputEventScreenDrag):
	pump.update_touch_position(event.position)

func is_point_on_pump(point):
	return pump.is_point_on_handle(point)

func add_pressure(amount):
	var min_pressure = manometr.min_pressure
	var max_pressure = manometr.max_pressure
	
	current_pressure += amount
	
	current_pressure = clamp(current_pressure, min_pressure, max_pressure)
	
	manometr.update_strelka(current_pressure)
	
	if pump_sound and amount > 0:
		pump_sound.pitch_scale = 0.9 + randf() * 0.2
		pump_sound.play()
		
		stop_hiss_sound()
	
	if current_pressure >= max_pressure:
		game_over("ВЗРЫВ! Слишком большое давление!")

func release_pressure(amount):
	if not game_active:
		return
	
	var old_pressure = current_pressure
	current_pressure -= amount
	
	current_pressure = max(current_pressure, manometr.min_pressure)

	manometr.update_strelka(current_pressure)
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
	
	if current_pressure >= 2.0 and current_pressure <= 2.6:
		win_game("Победа! Норм накачал!")
	elif current_pressure > 2.6:
		game_over("Перекачал! Красная зона!")
	else:
		game_over("Недокачал... Так и поедешь?")

func game_over(message):
	game_active = false
	stop_hiss_sound()
	print("GAME OVER: ", message)

func win_game(message):
	game_active = false
	stop_hiss_sound()
	print("WIN: ", message)
