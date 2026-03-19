extends Node2D
@export var timer_time: float
@onready var timer: Timer = $game_world/Timer
@onready var game_world: Node = $game_world

signal win
signal lose

func _ready():
	timer.wait_time = timer_time
	game_world.score_overed.connect(_win)
	timer.timeout.connect(_lose)
	
func _win():
	win.emit()
	
func _lose():
	lose.emit()
