extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var direction = Vector2.RIGHT
var speed: int  = 200
signal fired

func set_direction(new_direction: Vector2):
	direction = new_direction

func set_speed(new_speed: int):
	speed = new_speed
func _ready():
	body_entered.connect(_on_body_entered)
	
func _process(delta: float) -> void:
	global_position.x += speed*delta
	animated_sprite.play("default")
	
func _on_body_entered(body):
	if body.is_in_group("green_player"):
		fired.emit()
