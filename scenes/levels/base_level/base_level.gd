extends Node2D

@onready var timer_bar: ProgressBar = $CanvasLayer/TimerBar
@onready var timer: Timer = $CanvasLayer/TimerBar/Timer
var win_scene_preload = preload("res://scenes/menu/win_scene/win-scene.tscn")
var lose_scene_preload = preload("res://scenes/menu/lose_scene/LoseScene.tscn")
var times = [10, 7, 5]
var game_paths = [	
	"res://scenes/levels/tap-game/tap_game.tscn",
	"res://scenes/levels/PumpGame/pump_game.tscn",
	"res://scenes/levels/FireGame/FireGame.tscn", 
	
]

var game: Node
var current_result_scene: Node 
var game_path_id = 0
var time_index = 0

func _ready():
	_load_current_game()
	

func _set_timer_bar():
	print("Начали настройку тайм бара")
	if time_index >= times.size():
		return
		
	timer.wait_time = times[time_index]
	timer_bar.max_value = timer.wait_time
	timer_bar.value = timer.wait_time

	timer.start()
	print("Настройка тайм бара закончена")
	

func _process(delta):
	if timer and timer.is_stopped() == false:
		timer_bar.value = timer.time_left

func _load_current_game():
	if game_path_id < game_paths.size() and time_index < times.size():
		var path = game_paths[game_path_id]
		game = load(path).instantiate()
		game.timer_time = times[time_index]
		
		game.win.connect(_win_ending)
		game.lose.connect(_lose_ending)		
		_set_timer_bar()
		add_child(game)
		

	else:
		_back_to_menu()
	
func _win_ending():
	timer.stop()
	
	game.process_mode = Node.PROCESS_MODE_DISABLED
	current_result_scene = win_scene_preload.instantiate()
	current_result_scene.continue_game.connect(_on_game_continued)
	add_child(current_result_scene)
	
func _lose_ending():
	timer.stop()
	
	game.process_mode = Node.PROCESS_MODE_DISABLED
	current_result_scene = lose_scene_preload.instantiate()
	current_result_scene.restart_level.connect(_on_level_restarted)
	current_result_scene.back_to_main_menu.connect(_back_to_menu)
	add_child(current_result_scene)
	
func _on_game_continued():
	if current_result_scene:
		current_result_scene.queue_free()
		current_result_scene = null
	
	if game:
		game.queue_free()
		game = null
	
	game_path_id += 1
	time_index += 1
	_load_current_game()
	
func _on_level_restarted():
	if current_result_scene:
		current_result_scene.queue_free()
		current_result_scene = null
	
	get_tree().reload_current_scene()

func _back_to_menu():
	get_tree().change_scene_to_file("res://scenes/menu/main_menu/main_menu.tscn")
