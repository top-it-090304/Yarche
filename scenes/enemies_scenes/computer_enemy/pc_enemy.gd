extends CharacterBody2D
var direction = Vector2.RIGHT
var speed = 100
func _process(delta):
		
	velocity = direction*speed
	move_and_slide()
