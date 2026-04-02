extends Control
@onready var grid_container: GridContainer = $GridContainer
const LEVEL_BUTTON = preload("res://scenes/menu/level_menu/LevelButton.tscn")

func _ready():
	for i in range(1,15):
		var button = LEVEL_BUTTON.instantiate()
		button.level_number = i
		button.pressed.connect(func():
				get_tree().change_scene_to_file("res://scenes/levels/base_level/base_level.tscn"))
		grid_container.add_child(button)
