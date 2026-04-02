extends Node2D

@export var game_duration: float = 20.0  # 20 секунд активного спавна
@export var final_duration: float = 10.0  # 10 секунд финальной фазы

@onready var cloud_spawner = $CloudSpawner
@onready var plane = $Plane
@onready var background = $Control/Background

var game_state: String = "active"

func _ready():
	var timer = Timer.new()
	timer.wait_time = game_duration
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_game_timer_timeout)
	timer.start()
	
	print("Игра началась! 20 секунд полета с тучами")

func _on_game_timer_timeout():
	print("20 секунд прошло! Спавн туч остановлен, небо светлеет")
	
	cloud_spawner.stop_spawning()
	
	start_sky_lightening()
	
	var final_timer = Timer.new()
	final_timer.wait_time = final_duration
	final_timer.one_shot = true
	add_child(final_timer)
	final_timer.timeout.connect(_on_final_timer_timeout)
	final_timer.start()

func start_sky_lightening():
	var tween = create_tween()
	tween.tween_property(background, "color", Color(0.35, 0.6, 0.9), final_duration)
	
	var label = Label.new()
	label.text = "SPACE PHASE"
	label.position = Vector2(400, 100)
	add_child(label)
	var label_tween = create_tween()
	label_tween.tween_property(label, "modulate:a", 0.0, 10.0)

func _on_final_timer_timeout():
	print("ПОБЕДА! Игрок продержался 30 секунд")
	if plane:
		plane.is_game_active = false
	var win_label = Label.new()
	win_label.text = "YOU WIN!"
	win_label.position = Vector2(400, 300)
	add_child(win_label)
