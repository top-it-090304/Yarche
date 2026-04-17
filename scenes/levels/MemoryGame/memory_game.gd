extends Node2D

@export var game_buttons: Array[GameButton] = []
@onready var paper_note = $GameWorld/PaperNote

@export var show_duration = 4.0
@export var input_time_limit = 15.0

var current_sequence: Array[GameButton] = []
var player_sequence: Array[GameButton] = []
var waiting_for_input: bool = false
var game_timer: Timer
var game_active: bool = true

func _ready():
	game_timer = Timer.new()
	add_child(game_timer)
	game_timer.timeout.connect(_on_timer_timeout)
	
	for button in game_buttons:
		button.on_pressed.connect(_on_game_button_pressed)
	
	start_game()

func start_game():
	current_sequence.clear()
	player_sequence.clear()
	waiting_for_input = false
	game_active = true
	
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
	waiting_for_input = true
	game_timer.start(input_time_limit)

func _on_game_button_pressed(button: GameButton):
	if not waiting_for_input or not game_active:
		return
	
	button.animate_press()
	player_sequence.append(button)
	
	var current_index = player_sequence.size() - 1
	
	print("Нажата кнопка: ", button.button_id)
	print("Ожидалась: ", current_sequence[current_index].button_id)
	
	if player_sequence[current_index].button_id != current_sequence[current_index].button_id:
		end_game(false)
		return
	
	if player_sequence.size() == 3:
		end_game(true)

func _on_timer_timeout():
	if waiting_for_input and game_active:
		end_game(false)

func end_game(is_win):
	game_active = false
	waiting_for_input = false
	game_timer.stop()
	
	if is_win:
		print("Выиграли")
	else:
		print("Проиграли")
