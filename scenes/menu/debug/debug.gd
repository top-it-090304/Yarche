extends Control
@onready var completed: VBoxContainer = $completed
@onready var develop: VBoxContainer = $develop

var completed_levels = [
	"res://scenes/levels/FlappyPlaneGame/flappy_plane_game.tscn",
	"res://scenes/levels/CleanGame/CleanGame.tscn",
	"res://scenes/levels/PotatoGame/PotatoGame.tscn",
	"res://scenes/levels/PumpGame/pump_game.gd",
	"res://scenes/levels/AvoidTheGarbage/AvoidTheGarbage.tscn",
	"res://scenes/levels/HitTheBeaverGame/HitTheBeaverGame.tscn",
	"res://scenes/levels/MemoryGame/memory_game.tscn",
	"res://scenes/levels/PapersGame/PapersGame.tscn",
	"res://scenes/levels/WiresGame/wires_game.tscn",
	"res://scenes/levels/WaterMineGame/WaterMineGame.tscn"
]
var develop_levels = [
	"res://scenes/levels/SniperFindGame/sniper_find_game.tscn",
]
func _ready() -> void:
	connect_completed_levels()
	connect_develop_levels()
	
func _load_level(path):
	var level = load(path)
	var scene = level.instantiate()
	
	add_child(scene)
	
func connect_completed_levels():
	var i = 0
	for button in completed.get_children():
		button.pressed.connect(func():
			get_tree().change_scene_to_file(completed_levels[i]))
		i +=1
func connect_develop_levels():
	var i = 0
	for button in develop.get_children():
		button.pressed.connect(func():
			get_tree().change_scene_to_file(develop_levels[i]))
		i +=1
