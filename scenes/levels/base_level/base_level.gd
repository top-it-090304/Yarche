extends Node2D

@onready var timer_bar: ProgressBar = $CanvasLayer/TimerBar
@onready var timer: Timer = $CanvasLayer/TimerBar/Timer
var win_scene_preload = preload("res://scenes/menu/win_scene/win-scene.tscn")
var lose_scene_preload = preload("res://scenes/menu/lose_scene/LoseScene.tscn")

var level_data = [
	{"time": 10, "path": "res://scenes/levels/PotatoGame/PotatoGame.tscn"},
	{"time": 10, "path": "res://scenes/levels/MemoryGame/memory_game.tscn"},
	{"time": 10, "path": "res://scenes/levels/PapersGame/PapersGame.tscn"},
	{"time": 26, "path": "res://scenes/levels/AvoidTheGarbage/AvoidTheGarbage.tscn"},
	{"time": 8, "path": "res://scenes/levels/PumpGame/pump_game.tscn"},
	{"time": 5, "path": "res://scenes/levels/CleanGame/CleanGame.tscn"},
	{"time": 10, "path": "res://scenes/levels/FlappyPlaneGame/flappy_plane_game.tscn"},
	{"time": 12, "path": "res://scenes/levels/HitTheBeaverGame/HitTheBeaverGame.tscn"},
	{"time": 12, "path": "res://scenes/levels/WiresGame/wires_game.tscn"},
]

var game: Node
var current_result_scene: Node
var current_game_id = 0

func _ready():
	_load_current_game()
	

func _set_timer_bar(time):
		
	timer.wait_time = time
	timer.one_shot = true
	timer_bar.max_value = timer.wait_time
	timer_bar.value = timer.wait_time

	timer.start()
	print("Настройка тайм бара закончена")
	

func _process(delta):
	if timer and timer.is_stopped() == false:
		timer_bar.value = timer.time_left

func _load_current_game():
	if current_game_id < level_data.size():
		var path = level_data[current_game_id].path
		var time = level_data[current_game_id].time
		game = load(path).instantiate()
		game.timer_time = time
		
		game.win.connect(_win_ending)
		game.lose.connect(_lose_ending)		
		_set_timer_bar(time)
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
	
	current_game_id +=1
	_load_current_game()
	
func _on_level_restarted():
	if current_result_scene:
		current_result_scene.queue_free()
		current_result_scene = null
	
	get_tree().reload_current_scene()

func _back_to_menu():
	get_tree().change_scene_to_file("res://scenes/menu/main_menu/main_menu.tscn")
