extends Area2D
class_name GameButton

@export var button_id = ""
@export var button_color = Color.WHITE
@export var default_texture: Texture2D  

@onready var sprite_2d = $Sprite2D

signal on_pressed(button: GameButton)

var is_interactable = true
var original_scale: Vector2
var tween: Tween

func _ready():
	original_scale = scale
	
	if default_texture:
		sprite_2d.texture = default_texture
	
	sprite_2d.modulate = button_color
	
	input_event.connect(_on_input_event)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if not is_interactable:
		return
	
	if event is InputEventScreenTouch and event.pressed:
		on_touch()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		on_touch()

func on_touch():
	animate_press()
	
	on_pressed.emit(self)

func animate_press():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(self, "scale", original_scale * 0.85, 0.08)
	tween.tween_property(self, "scale", original_scale, 0.12)

func set_interactable(value):
	is_interactable = value
	$CollisionShape2D.disabled = not value
	
	if not value:
		sprite_2d.modulate.a = 0.5
	else:
		sprite_2d.modulate.a = 1.0

func flash():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.1)
	tween.tween_property(sprite_2d, "modulate", button_color, 0.1)
