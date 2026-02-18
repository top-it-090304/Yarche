extends CharacterBody2D
var speed = 150
var direction = Vector2.RIGHT

func _process(delta: float) -> void:
	velocity = direction*speed
	move_and_slide()
