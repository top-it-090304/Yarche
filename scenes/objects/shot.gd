extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var direction = Vector2.RIGHT
var speed: int  = 200

func set_direction(new_direction: Vector2):
	direction = new_direction

func set_speed(new_speed: int):
	speed = new_speed
	
func _process(delta: float) -> void:
	position += direction*speed*delta
	animated_sprite.play("default")
