extends Node2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var flame: Node2D = $Flame
@onready var timer: Timer = $Timer

@export var timer_time = 1
var win_scene = preload("res://scenes/menu/win_scene/win-scene.tscn")
var lose_scene = preload("res://scenes/menu/lose_scene/LoseScene.tscn")
signal continue_game
signal restart
signal back_to_menu

func _ready():
	timer.wait_time = timer_time
	audio_stream_player.over_threshold.connect(on_sound)
	flame.win.connect(_win_ending)
	
func on_sound():
	flame.decrease_scale()
func _win_ending():
	timer.queue_free()
	get_tree().paused = true
	var win_scene_instance = win_scene.instantiate()
	win_scene_instance.continue_game.connect(_continue)
	add_child(win_scene_instance)

func _lose_ending():
	get_tree().paused = true
	var lose_scene_instance = lose_scene.instantiate()
	lose_scene_instance.restart_level.connect(_restart)
	lose_scene_instance.back_to_main_menu.connect(_back_to_menu)
	add_child(lose_scene_instance)
	
	
func _continue():
	continue_game.emit()
func _back_to_menu():
	back_to_menu.emit()
func _restart():
	restart.emit()
