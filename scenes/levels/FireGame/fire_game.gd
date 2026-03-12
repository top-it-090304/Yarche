extends Node2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var flame: Node2D = $Flame
@onready var timer: Timer = $Timer

@export var timer_time = 1
signal win
signal lose

func _ready():
	get_tree().paused = true
	_connect_game_logics()
	show_tutorial()

	
func _connect_game_logics():
	timer.wait_time = timer_time
	timer.timeout.connect(_lose_ending)
	timer.one_shot = true
	timer.start()
	
	audio_stream_player.over_threshold.connect(on_sound)
	flame.win.connect(_win_ending)

func show_tutorial():
	var tutorial = preload("res://scenes/levels/FireGame/breath_tutorial.tscn").instantiate()
	tutorial.tutorial_finished.connect(_start_game)
	add_child(tutorial)

func _start_game():
	get_tree().paused = false
	
func on_sound():
	flame.decrease_scale()
func _win_ending():
	win.emit()

func _lose_ending():
	lose.emit()
	
	
