extends Node2D
signal lose
signal win
@export var timer_time: float = 10
@onready var timer: Timer = $Timer
@onready var gameworld: Node = $gameworld

func _ready() -> void:
	timer.wait_time = timer_time
	timer.one_shot = true
	
	gameworld.win.connect(func(): win.emit())
	gameworld.lose.connect(func(): lose.emit())
	timer.timeout.connect(func(): lose.emit())
