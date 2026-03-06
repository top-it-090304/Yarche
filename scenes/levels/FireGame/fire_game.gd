extends Node2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var flame: Node2D = $Flame
@onready var timer: Timer = $Timer
@export var timer_time = 1

signal end

func _ready():
	timer.wait_time = timer_time
	timer.timeout.connect(_end_emit)
	audio_stream_player.over_threshold.connect(on_sound)
	flame.win.connect(_end_emit)
	
func on_sound():
	flame.decrease_scale()
func _end_emit():
	end.emit()
