extends CanvasLayer
@export var tutorial_skipable = true
@onready var timer = $Timer
@onready var sprite: AnimatedSprite2D = $Control/Control/tutorial_frames

signal tutorial_finished

func _ready():
	sprite.play()
	
	timer.wait_time = 3.0
	timer.one_shot = true
	timer.timeout.connect(_on_tutorial_timeout)
	timer.start()

func _on_tutorial_timeout():
	emit_signal("tutorial_finished")
	queue_free()

func skip_tutorial():
	timer.stop()
	_on_tutorial_timeout()

func _input(event):
	if event is InputEventScreenTouch and event.pressed and tutorial_skipable:
		skip_tutorial()
