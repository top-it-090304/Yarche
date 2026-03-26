extends CharacterBody2D

var gravity = 1200.0
var flap_force = -400.0
var is_game_active = true  

func _physics_process(delta):
	if not is_game_active:
		return
	
	velocity.y += gravity * delta
	move_and_slide()
	
	#for i in range(get_slide_collision_count()):
		#var collision = get_slide_collision(i)
		#if collision.get_collider().is_in_group("clouds"):
			#die()
	
	if position.y < 0 or position.y > get_viewport_rect().size.y:
		die()

func _input(event):
	if not is_game_active:
		return
	if event is InputEventScreenTouch:
		if event.pressed: 
			flap()

func flap():
	velocity.y = flap_force
	print("Flap!")

func die():
	is_game_active = false
	print("Game Over")
