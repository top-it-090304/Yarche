extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed = 150
var accceleration = 20.0
var max_speed = 500

var direction = Vector2.RIGHT
func _input(event: InputEvent) -> void:
	if event == InputEventScreenTouch and speed<max_speed:
		speed += accceleration
	elif speed>150:
		speed-= accceleration*0.01
			
func _process(delta):
		
	animated_sprite_2d.play("walk")
	velocity = direction*speed
	move_and_slide()
