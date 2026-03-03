extends CanvasLayer

@onready var animated_sprite = $Panel/AnimatedSprite2D
@onready var timer = $Timer

signal tutorial_finished

func _ready():
	animated_sprite.play()
	
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
	if event is InputEventScreenTouch and event.pressed:
		skip_tutorial()
