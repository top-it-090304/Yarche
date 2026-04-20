extends Node2D
@onready var timer: Timer = $Timer
@onready var potato: Node2D = $gameworld/swipe_analyzer/Potato

signal win
signal lose
@export var timer_time: float = 4.0

func _ready():
	timer.wait_time = timer_time
	timer.timeout.connect(_lose)
	potato.is_clean.connect(_win)
	
	timer.start()

#func show_tutorial():
	#get_tree().paused = true
	#var tutorial = preload("res://scenes/levels/CleanGame/Clean_tutorial.tscn").instantiate()
	#add_child(tutorial)
	#tutorial.tutorial_finished.connect(_start_game)

func _start_game():
	get_tree().paused = false

func _win():
	win.emit()
	print("Выиграли")
func _lose():
	lose.emit()
	print("Проиграли")
	
