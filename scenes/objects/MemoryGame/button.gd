extends Button
class_name GameButton

@export var button_id = ""
@export var button_color = Color.WHITE
@export var shape_texture : Texture2D

signal on_pressed(button: GameButton)

func _ready():
	modulate = button_color
	if shape_texture:
		icon = shape_texture
		expand_icon = true
		icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pressed.connect(func(): on_pressed.emit(self))

func flash():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	tween.tween_property(self, "modulate", button_color, 0.1)
