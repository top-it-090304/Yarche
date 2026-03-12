extends Area2D

@export var color_type = "red"
@onready var socket = $Socket

func _ready():
	add_to_group("sockets")
	match color_type:
		"red":
			socket.modulate = Color.RED
		"blue":
			socket.modulate = Color.BLUE
		"green":
			socket.modulate = Color.GREEN
		"yellow":
			socket.modulate = Color.YELLOW
