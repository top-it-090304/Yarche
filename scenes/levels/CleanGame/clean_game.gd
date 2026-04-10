extends Node2D
@onready var banana: Area2D = $gameworld/Banana
@onready var timer: Timer = $Timer

signal win
signal lose
@export var timer_time: float = 4.0

func _ready():
	timer.wait_time = timer_time
	timer.timeout.connect(_lose)
	banana.come_back.connect(_win)
	
	timer.start()

func _win():
	win.emit()
	print("Выиграли")
func _lose():
	lose.emit()
	print("Проиграли")
	
