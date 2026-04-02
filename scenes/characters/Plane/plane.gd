extends CharacterBody2D

var gravity = 1200.0
var flap_force = -400.0
var is_game_active = true  
var has_started = false

# Параметры для наклона
var rotation_speed = 4.0 
var max_rotation_up = -0.5  
var max_rotation_down = 0.8 
var flap_rotation = -0.3

var main_scene

func _ready():
	main_scene = get_parent()
	set_physics_process(false)

func _physics_process(delta):
	if not is_game_active or not has_started:
		return
	
	velocity.y += gravity * delta
	move_and_slide()
	
	update_rotation(delta)
	
	if position.y < 0 or position.y > get_viewport_rect().size.y:
		die()

func _input(event):
	if not is_game_active:
		return
	
	if event is InputEventScreenTouch and event.pressed:
		if not has_started:
			start_game()
		else:
			flap()

func start_game():
	has_started = true
	set_physics_process(true)  
	flap()

func flap():
	velocity.y = flap_force
	rotation = flap_rotation

func update_rotation(delta):
	var target_rotation = 0.0
	
	if velocity.y < 0:
		target_rotation = max_rotation_up * (velocity.y / flap_force)
		target_rotation = clamp(target_rotation, max_rotation_up, 0)
	else:
		target_rotation = max_rotation_down * (velocity.y / 800.0)
		target_rotation = clamp(target_rotation, 0, max_rotation_down)
	
	rotation = lerp(rotation, target_rotation, rotation_speed * delta)

func die():
	is_game_active = false
	set_physics_process(false)
	main_scene.game_over()
