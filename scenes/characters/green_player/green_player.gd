extends CharacterBody2D
var is_win = false

var direction = Vector2.RIGHT
var MIN_SPEED = 150.0
var MAX_SPEED  = 1000.0
var friction = 0.98
var impulse_force = 200.0

func _ready():
	$AnimationPlayer.play("run")
	
func _physics_process(delta):
	if not is_win:
		velocity.x *= friction
		velocity.x = clamp(velocity.x, MIN_SPEED, MAX_SPEED)
		print(velocity.x)
		$AnimationPlayer.speed_scale = velocity.x/MIN_SPEED
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func accelerate():
	if not is_win:
		velocity.x += impulse_force

func stop():
	is_win = true
	velocity = Vector2.ZERO
	$AnimationPlayer.speed_scale = 1.0
	$AnimationPlayer.play("smile")

func set_min_speed(new_min_speed):
	MIN_SPEED = new_min_speed
	
func set_max_speed(new_max_speed):
	MAX_SPEED = new_max_speed
