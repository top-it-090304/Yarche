extends Node2D

@onready var rod_container = $RodContainer
@onready var rod_handle = $RodContainer/RodHandle

var rod_min_y = -290.0   
var rod_max_y = -50.0
var rod_current_y = -170.0

var target_y = -170.0
var speed = 15.0

func _ready():
	rod_container.position.y = rod_current_y
	target_y = rod_current_y

func _process(delta):
	rod_container.position.y = lerp(rod_container.position.y, target_y, speed * delta)

func swipe_up():
	target_y = rod_min_y
	print("Шток вверх")

func swipe_down():
	target_y = rod_max_y
	print("Шток вниз")

func swipe_end():
	target_y = rod_current_y
