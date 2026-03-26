extends Node2D
@onready var fish: CharacterBody2D = $gameworld/Control/Fish
@onready var timer: Timer = $Timer
@export var timer_time: float = 2

signal win
signal lose

func _ready():
	timer.wait_time = timer_time
	
	timer.timeout.connect(_win_ending)
	fish.fish_hited.connect(_lose_ending)
	
	timer.start()
	
func _win_ending():
	win.emit()

func _lose_ending():
	lose.emit()
