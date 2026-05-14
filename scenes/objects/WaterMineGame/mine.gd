extends RigidBody2D
signal exploded
signal deleted
@onready var particles: GPUParticles2D = $GPUParticles2D

var move_direction
var speed = 100
@onready var sprite: Sprite2D = $Sprite2D

var is_dissolving = false
var is_exploded = false
func _ready() -> void:
	
	angular_velocity = deg_to_rad(30)
	angular_damp = 0.0	
	connect("input_event", _on_mine_clicked)


func dissolve_sprite():
	var tween = create_tween()
	tween.tween_property(self,"modulate", Color(1,1,1,0),0.5)
	tween.tween_callback(dissolve_end)
	
func set_sprite_dissolve(value):
	sprite.material.set_shader_parameter("strength", value)
	

func _on_mine_clicked(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.pressed and not is_dissolving:
		dissolve_sprite()
		
func explode():
	if is_dissolving or is_exploded: return
	is_dissolving = true
	is_exploded = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.5,1.5), 0.9).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(sprite, "modulate", Color.ORANGE_RED, 0.3)
	tween.tween_property(sprite, "modulate", Color.RED, 0.3)
	tween.tween_property(sprite, "modulate", Color.ORANGE, 0.3)
	
	await get_tree().create_timer(0.9).timeout
	sprite.visible = false
	particles.emitting = true
	
	await get_tree().create_timer(0.5).timeout
	exploded.emit()
	queue_free()
	
func dissolve_end():
	deleted.emit()
	print("удалена мина")
	queue_free()
	
func set_move_dir(target):
	move_direction = target.global_position - self.global_position
	move_direction = move_direction.normalized()
	
	linear_velocity = move_direction * speed
