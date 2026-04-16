extends Node2D
@export var timer_time: float
@onready var timer: Timer = $GameTimer
@onready var game_world: Node = $game_world

signal win
signal lose

func _ready():
	timer.wait_time = timer_time
	game_world.all_checked.connect(_win)
	timer.timeout.connect(_lose)
	timer.start()


func _win():
	win.emit()
	
func _lose():
	lose.emit()

func _start_game():
	get_tree().paused = false
