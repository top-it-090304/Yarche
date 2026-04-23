extends RigidBody2D

var shader = preload("res://assets/shaders/dissolve_shader.tres")

var move_direction
var speed = 100
@onready var sprite: Sprite2D = $Sprite2D

var is_dissolving = false

func _ready() -> void:
	sprite.material = shader.duplicate()
	connect("input_event", _on_mine_clicked)

func _process(delta: float) -> void:
	sprite.rotate(delta*0.2)

func dissolve_sprite():
	var tween = create_tween()
	tween.tween_method(set_sprite_dissolve, 0.0,0.65,0.5)
	tween.tween_callback(queue_free)
	
func set_sprite_dissolve(value):
	sprite.material.set_shader_parameter("strength", value)
	print(value)
	
func _on_mine_clicked(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.pressed and not is_dissolving:
		dissolve_sprite()
		is_dissolving = true
		
func set_move_dir(target):
	move_direction = target.global_position - self.global_position
	move_direction = move_direction.normalized()
	
	linear_velocity = move_direction * speed
