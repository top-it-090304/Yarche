extends CharacterBody2D
var speed = 150.0
var acceleration = 30.0
var direction = Vector2.RIGHT
var MIN_SPEED = 150.0
var MAX_SPEED  = 1000.0

func set_min_speed(new_min_speed):
	MIN_SPEED = new_min_speed
	
func set_max_speed(new_max_speed):
	MAX_SPEED = new_max_speed
		
func accelerate(acceleration = 30):
	if speed <MAX_SPEED:
		speed += acceleration*(1/(speed/MAX_SPEED))
	
func _process(delta: float) -> void:
	if speed > MIN_SPEED:
		speed -= 200*delta
	
	velocity = direction*speed
	move_and_slide()
