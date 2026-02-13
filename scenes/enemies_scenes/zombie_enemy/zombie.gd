extends CharacterBody2D
var speed = 200
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	var direction = Vector2.RIGHT
	animated_sprite_2d.play("walk")
	velocity = direction*speed
	move_and_slide()
