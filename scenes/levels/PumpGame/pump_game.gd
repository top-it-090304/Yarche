extends Node2D

@onready var pump = $Pump
@onready var manometr = $Manometr
@onready var timer_bar = $"../TimerBar"
@onready var game_timer = $GameTimer

# Параметры игры
var current_pressure = 0.0
var game_active = true
var game_time = 20.0  # секунд

# Для отслеживания касания ручки
var touching_pump = false
var pump_touch_index = -1  # ID касания

func _ready():
	# Настройка таймера
	game_timer.wait_time = game_time
	game_timer.one_shot = true
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()
	
	# Настройка прогресс-бара
	timer_bar.max_value = game_time
	timer_bar.value = game_time
	
	# Начальное давление
	current_pressure = 0.0
	manometr.update_strelka(current_pressure)

func _process(delta):
	if game_active:
		# Обновляем прогресс-бар
		timer_bar.value = game_timer.time_left

func _input(event):
	if not game_active:
		return
	
	if event is InputEventScreenTouch:
		handle_touch_event(event)
	
	elif event is InputEventScreenDrag and touching_pump and event.index == pump_touch_index:
		# Обрабатываем движение пальца только если это касание ручки
		handle_drag_event(event)

func handle_touch_event(event: InputEventScreenTouch):
	if event.pressed:
		# Проверяем, коснулся ли игрок ручки насоса
		if is_point_on_pump(event.position):
			touching_pump = true
			pump_touch_index = event.index
			pump.start_touch(event.position)
	else:
		# Если палец отпущен и это было касание ручки
		if event.index == pump_touch_index:
			touching_pump = false
			pump_touch_index = -1
			pump.end_touch()

func handle_drag_event(event: InputEventScreenDrag):
	# Передаем позицию драга в насос
	pump.update_touch_position(event.position)

func is_point_on_pump(point: Vector2) -> bool:
	# Вместо использования get_pump_size, вызываем метод is_point_on_handle напрямую
	return pump.is_point_on_handle(point)

func add_pressure(amount):
	current_pressure += amount
	manometr.update_strelka(current_pressure)
	
	# Проверка на взрыв
	

func _on_game_timer_timeout():
	if not game_active:
		return
		
	# Время вышло - проверяем победу
	if current_pressure >= 2.0 and current_pressure <= 2.8:
		win_game("Победа! Норм накачал!")
	elif current_pressure > 2.8:
		game_over("Перекачал! Красная зона!")
	else:
		game_over("Недокачал... Так и поедешь?")

func game_over(message):
	game_active = false
	print("GAME OVER: ", message)
	# Покажи окно с сообщением и кнопкой рестарта

func win_game(message):
	game_active = false
	print("WIN: ", message)
	# Покажи поздравление
