extends Node2D

@export var game_buttons: Array[GameButton] = []
@onready var paper_note = $GameWorld/PaperNote
@onready var game_timer = $GameWorld/Timer

@export var show_duration = 3.0
@export var timer_time = 15.0

var current_sequence: Array[GameButton] = []
var player_sequence: Array[GameButton] = []
var waiting_for_input = false
var game_active= true

var tutorial_scene = preload("res://scenes/levels/MemoryGame/memory_game_tutorial.tscn")

signal win
signal lose

func _ready():
	show_tutorial()
	game_timer.wait_time = timer_time
	game_timer.timeout.connect(_on_timer_timeout)
	
	for button in game_buttons:
		button.on_pressed.connect(_on_game_button_pressed)

func show_tutorial():
	get_tree().paused = true
	var tutorial = tutorial_scene.instantiate()
	tutorial.tutorial_finished.connect(start_game)
	add_child(tutorial)

func _on_tutorial_finished():
	await get_tree().create_timer(0.1).timeout
	start_game()

func start_game():
	current_sequence.clear()
	player_sequence.clear()
	waiting_for_input = false
	game_active = true
	
	get_tree().paused = true
	
	var available_buttons = game_buttons.duplicate()
	available_buttons.shuffle()
	
	for i in range(3):
		current_sequence.append(available_buttons[i])
	
	show_combination()

func show_combination():
	paper_note.show_combination(current_sequence)
	paper_note.visible = true
	paper_note.modulate.a = 1.0
	
	await get_tree().create_timer(show_duration).timeout
	
	paper_note.fly_away()
	await get_tree().create_timer(0.3).timeout
	
	start_input_phase()

func start_input_phase():
	get_tree().paused = false
	waiting_for_input = true
	game_timer.start()

func _on_game_button_pressed(button: GameButton):
	if not waiting_for_input or not game_active:
		return
	
	button.animate_press()
	player_sequence.append(button)
	
	var current_index = player_sequence.size() - 1
	
	print("Нажата кнопка: ", button.button_id)
	print("Ожидалась: ", current_sequence[current_index].button_id)
	
	if player_sequence[current_index].button_id != current_sequence[current_index].button_id:
		await button.animation_finished
		end_game(false)
		return
	
	if player_sequence.size() == 3:
		await button.animation_finished
		end_game(true)

func _on_timer_timeout():
	if waiting_for_input and game_active:
		end_game(false)

func end_game(is_win):
	get_tree().paused = false
	game_active = false
	waiting_for_input = false
	game_timer.stop()
	
	if is_win:
		win.emit()
	else:
		lose.emit()
