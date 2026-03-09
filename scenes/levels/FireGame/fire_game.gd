extends Node2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var flame: Node2D = $Flame
@onready var timer: Timer = $Timer

@export var timer_time = 1
var ending_win_scene = preload("res://scenes/menu/win_scene/win-scene.tscn")
signal end

func _ready():
	timer.wait_time = timer_time
	audio_stream_player.over_threshold.connect(on_sound)
	flame.win.connect(_win_ending)
	
func on_sound():
	flame.decrease_scale()
func _win_ending():
	var win_scene_instance = ending_win_scene.instantiate()
	win_scene_instance.continue_game.connect(_end_emit)
	add_child(win_scene_instance)

func _end_emit():
	end.emit()
