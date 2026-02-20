extends Node2D

@onready var pump = $Pump
@onready var manometr = $Manometr
@onready var timer_bar = $TimerBar
@onready var game_timer = $GameTimer

# Параметры игры
var current_pressure = 0.0
var game_active = true
var game_time = 20.0  # секунд

# Для свайпов
var start_pos = Vector2.ZERO
var last_swipe_was_up = false
var min_swipe_length = 50

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
		if event.pressed:
			start_pos = event.position
		else:
			check_swipe(event.position)

func check_swipe(end_pos):
	var vector = end_pos - start_pos
	
	# Проверка длины свайпа
	if vector.length() < min_swipe_length:
		return
	
	# Определяем направление
	if abs(vector.x) > abs(vector.y):
		game_over("Горизонтальный свайп! Насос сломан!")
		return
	
	# Вертикальный свайп
	if vector.y < -min_swipe_length:  # ВВЕРХ
		pump.swipe_up()
		last_swipe_was_up = true
		
	elif vector.y > min_swipe_length:  # ВНИЗ
		if last_swipe_was_up:
			pump.swipe_down()
			add_pressure(0.1)
			last_swipe_was_up = false
		else:
			# Можно просто игнорировать или предупредить
			print("Сначала подними шток!")
	
	# Возврат ручки
	pump.swipe_end()

func add_pressure(amount):
	current_pressure += amount
	manometr.update_strelka(current_pressure)
	
	# Проверка на взрыв
	if current_pressure >= 3.9:
		game_over("БДЫЩ! Перекачал до взрыва!")

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
