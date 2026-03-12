extends Node2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var flame: Node2D = $Flame
@onready var timer: Timer = $Timer

@export var timer_time = 1
signal win
signal lose

func _ready():
	timer.wait_time = timer_time
	audio_stream_player.over_threshold.connect(on_sound)
	flame.win.connect(_win_ending)
	
func on_sound():
	flame.decrease_scale()
func _win_ending():
	get_tree().paused = true
	win.emit()

func _lose_ending():
	get_tree().paused = true
	lose.emit()
	
	
