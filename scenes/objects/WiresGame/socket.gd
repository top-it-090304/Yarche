extends Area2D

@export var color_type = "red"
@onready var socket = $Socket

func _ready():
	add_to_group("sockets")
	match color_type:
		"red":
			socket.modulate = Color(0.9, 0.2, 0.15)
		"blue":
			socket.modulate = Color(0.0, 0.4, 1)
		"green":
			socket.modulate = Color.GREEN
		"yellow":
			socket.modulate = Color.YELLOW
