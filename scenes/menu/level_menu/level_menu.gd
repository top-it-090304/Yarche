extends Control
@onready var grid_container: GridContainer = $GridContainer
const LEVEL_BUTTON = preload("res://scenes/menu/level_menu/LevelButton.tscn")
signal rendered
func _ready():
	for i in range(1,15):
		var button = LEVEL_BUTTON.instantiate()
		button.level_number = i
		grid_container.add_child(button)
