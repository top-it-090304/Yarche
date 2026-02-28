extends TextureButton
@onready var label: Label = $Label
@export var level_number: int

func _ready():
	if level_number:
		label.text = str(level_number)
