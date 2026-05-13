extends CharacterBody2D

var direction = Vector2.RIGHT
var speed = 250.0
var MAX_SPEED = 500.0
var MIN_SPEED = 100.0
var impulse_force = 20
var is_win = false

@onready var shoot_timer: Timer = $Timer
@onready var spawn_points: Node2D = $spawn_points
var cooldown = 0.5
const bullet_scene = preload("res://scenes/objects/shot/shot.tscn")
var bullet_speed = speed*4
var current_bullet = null
var index = 0
signal hit

func _ready():
	$BodyAnimator.play("run")
	$AnimationPlayer.play("wheels_animation")
	
	shoot_timer.wait_time = cooldown
	shoot_timer.timeout.connect(on_shoot_timer_timeout)
	shoot_timer.start()
	
func on_shoot_timer_timeout():
	print("shoot")
	if current_bullet != null:
		current_bullet.queue_free()
	var points = spawn_points.get_children()
	if points.size() >0:
		current_bullet = spawn_bullet(points[index])
		index +=1
		if index >= points.size():
			index = 0
			
func set_max_speed(new_max_speed):
	MAX_SPEED = new_max_speed

func spawn_bullet(spawn_point):
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		
		bullet.global_position = spawn_point.global_position
		bullet.set_speed(bullet_speed)
		bullet.set_direction(direction)
		get_tree().current_scene.add_child(bullet)
		bullet.fired.connect(_on_bullet_fired)
		return bullet
	return null
	
func _on_bullet_fired():
	emit_signal("hit")
	current_bullet.queue_free()
	
func accelerate():
	velocity.x += impulse_force

func _physics_process(delta):
	if not is_win:	
		velocity.x = clamp(velocity.x, MIN_SPEED, MAX_SPEED)
		move_and_slide()
		

func stop():
	is_win = true
	velocity.x = 0
	$BodyAnimator.speed_scale = 0.5
	$AnimationPlayer.speed_scale = 0.0
	shoot_timer.timeout.disconnect(on_shoot_timer_timeout)
