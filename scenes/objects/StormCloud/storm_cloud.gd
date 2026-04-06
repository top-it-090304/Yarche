extends Area2D

var speed = 300.0

func _ready():
	add_to_group("clouds")
	body_entered.connect(_on_body_entered)

func _process(delta):
	position.x -= speed * delta
	
	if position.x < -500:
		queue_free()

func _on_body_entered(body):
	if body.name == "Plane":
		body.die()
