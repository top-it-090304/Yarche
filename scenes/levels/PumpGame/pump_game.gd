extends Node2D

@onready var pump = $Pump
@onready var manometr = $Manometr
@onready var timer_bar = $"../TimerBar"
@onready var game_timer = $GameTimer
@onready var pump_sound = $PumpSound  # Добавляем звук насоса

var current_pressure
var game_active = true
var game_time = 15.0

var touching_pump = false
var pump_touch_index = -1

func _ready():
	game_timer.wait_time = game_time
	game_timer.one_shot = true
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()
	
	timer_bar.max_value = game_time
	timer_bar.value = game_time

	current_pressure = 0.0
	manometr.update_strelka(current_pressure)

func _process(delta):
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
	
	# Звук накачки - проигрываем каждый раз при добавлении давления
	if pump_sound and amount > 0:
		# Немного меняем высоту тона для разнообразия
		pump_sound.pitch_scale = 0.9 + randf() * 0.2
		pump_sound.play()
	
	# Проверка на красную зону
	if current_pressure >= 3.0:
		print("Осторожно! Высокое давление!")
	
	# Проверка на взрыв
	if current_pressure >= max_pressure:
		game_over("ВЗРЫВ! Слишком большое давление!")

func release_pressure(amount):
	if not game_active:
		return
	
	current_pressure -= amount
	
	current_pressure = max(current_pressure, manometr.min_pressure)

	manometr.update_strelka(current_pressure)

func _on_game_timer_timeout():
	if not game_active:
		return
	
	if current_pressure >= 2.0 and current_pressure <= 2.6:
		win_game("Победа! Норм накачал!")
	elif current_pressure > 2.8:
		game_over("Перекачал! Красная зона!")
	else:
		game_over("Недокачал... Так и поедешь?")

func game_over(message):
	game_active = false
	print("GAME OVER: ", message)

func win_game(message):
	game_active = false
	print("WIN: ", message)
