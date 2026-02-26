extends Node2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var flame: Node2D = $Flame

func _ready():
	audio_stream_player.over_threshold.connect(on_sound)
	
func on_sound():
	flame.decrease_scale()
