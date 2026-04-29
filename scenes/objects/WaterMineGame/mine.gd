extends RigidBody2D
signal exploded
signal deleted

var shader_dissolve = preload("res://assets/shaders/dissolve_shader.tres")
var shader_explode = preload("res://assets/shaders/explosion.gdshader")

var move_direction
var speed = 100
@onready var sprite: Sprite2D = $Sprite2D
@onready var explosion_particles: GPUParticles2D = $explosion_particles

var is_dissolving = false

func _ready() -> void:
	
	connect("input_event", _on_mine_clicked)

func _process(delta: float) -> void:
	sprite.rotate(delta*0.2)

func dissolve_sprite():
	sprite.material = shader_dissolve.duplicate()
	var tween = create_tween()
	tween.tween_method(set_sprite_dissolve, 0.0,0.65,0.5)
	tween.tween_callback(dissolve_end)
	
func set_sprite_dissolve(value):
	sprite.material.set_shader_parameter("strength", value)
	

func _on_mine_clicked(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.pressed and not is_dissolving:
		dissolve_sprite()
		
func explode():
	if is_dissolving: return
	is_dissolving = true
	
	
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.ORANGE, 0.2)
	tween.tween_property(sprite, "modulate", Color.ORANGE_RED, 0.2)
	tween.tween_property(sprite, "modulate", Color.RED, 0.2)
	tween.tween_callback(
		func():
			sprite.visible = false
			explosion_particles.emitting = true
			await get_tree().create_timer(explosion_particles.lifetime-0.7).timeout
			exploded.emit()
			queue_free()
	)
	
func dissolve_end():
	deleted.emit()
	print("удалена мина")
	queue_free()
	
func set_move_dir(target):
	move_direction = target.global_position - self.global_position
	move_direction = move_direction.normalized()
	
	linear_velocity = move_direction * speed
