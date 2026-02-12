extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed = 150
var accceleration = 20
var max_speed = 500

var direction = Vector2.RIGHT

func _process(delta: float) -> void:
	
	if Input.is_anything_pressed() and speed<max_speed:
		speed += accceleration
	elif speed>150:
		speed-= accceleration
	animated_sprite_2d.play("walk")
	velocity = direction*speed
	move_and_slide()
