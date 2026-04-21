extends Area2D
class_name GameButton

@export var button_id = ""
@export var button_color = Color.WHITE
@export var default_texture: Texture2D  

@onready var sprite_2d = $Sprite2D
@onready var click_sound = $ClickSound

signal on_pressed(button: GameButton)
signal animation_finished

var is_interactable = true
var can_press = true 
var original_scale: Vector2
var tween: Tween

func _ready():
	original_scale = scale
	
	if default_texture:
		sprite_2d.texture = default_texture
	
	sprite_2d.modulate = button_color
	
	input_event.connect(_on_input_event)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if not is_interactable or not can_press:
		return
	
	if event is InputEventScreenTouch and event.pressed:
		on_touch()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		on_touch()

func on_touch():
	if not can_press:
		return
	
	can_press = false
	animate_press()
	click_sound.play()
	on_pressed.emit(self)
	
	await get_tree().create_timer(0.3).timeout
	can_press = true

func animate_press():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(self, "scale", original_scale * 0.85, 0.08)
	tween.tween_property(self, "scale", original_scale, 0.12)
	
	tween.finished.connect(_on_animation_finished)

func _on_animation_finished():
	animation_finished.emit()
