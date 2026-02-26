extends Node2D

@onready var rod_handle = $RodHandle

var rod_min_y = -210.0   
var rod_max_y = -40.0
var rod_current_y = -125.0

var target_y = -125.0
var speed = 15.0

var handle_height = 50
var handle_width = 220  

var touch_start_y = 0.0
var rod_start_y = 0.0
var is_touching = false

var total_movement = 0.0
var last_position_y = 0.0
var pump_cooldown = false
var pump_efficiency = 0.125
var min_pump_force = 3.0

# Переменные для стравливания
var was_going_down = false
var leak_rate = 0.2            # Скорость стравливания в секунду
var last_pressure_time = 0.0

func _ready():
	rod_handle.position.y = rod_current_y
	target_y = rod_current_y
	last_position_y = rod_current_y

func _process(delta):
	rod_handle.position.y = move_toward(rod_handle.position.y, target_y, speed * delta * 60)
	rod_current_y = rod_handle.position.y
	
	if is_touching:
		check_pump_movement()
	release_pressure(delta)

func is_point_on_handle(point):
	var handle_global_pos = rod_handle.global_position
	
	var full_texture_size = rod_handle.texture.get_size() * rod_handle.scale
	
	var handle_rect = Rect2(
		handle_global_pos.x - handle_width/2,
		handle_global_pos.y - full_texture_size.y/2,
		handle_width,
		handle_height
	)
	
	handle_rect = handle_rect.grow(10)
	
	return handle_rect.has_point(point)

func start_touch(touch_pos):
	is_touching = true
	touch_start_y = touch_pos.y
	rod_start_y = rod_current_y
	last_position_y = rod_current_y
	total_movement = 0.0
	pump_cooldown = false
	was_going_down = false

func update_touch_position(touch_pos):
	if not is_touching:
		return
	
	var delta_y = touch_pos.y - touch_start_y
	var new_target = rod_start_y + delta_y * 0.5
	new_target = clamp(new_target, rod_min_y, rod_max_y)
	target_y = new_target

func end_touch():
	is_touching = false
	pump_cooldown = false

func check_pump_movement():
	var movement = rod_current_y - last_position_y
	
	if movement > 0.5:
		if not pump_cooldown:
			var pressure_amount = movement * pump_efficiency
			pressure_amount = clamp(pressure_amount, 0.01, 0.15)
			
			add_pressure_to_level(pressure_amount)
			
			pump_cooldown = true
			was_going_down = true
			total_movement += movement
			
			start_pump_cooldown()
	
	elif movement < -0.5:
		was_going_down = false
	
	last_position_y = rod_current_y

func start_pump_cooldown():
	await get_tree().create_timer(0.15).timeout
	pump_cooldown = false

func add_pressure_to_level(amount):
	var level = get_parent()
	if level and level.has_method("add_pressure"):
		level.add_pressure(amount)

func release_pressure(delta):
	var level = get_parent()
	if level and level.has_method("release_pressure"):
		var current_leak = leak_rate
		
		if is_touching:
			current_leak = leak_rate * 0.7 
		level.release_pressure(delta * current_leak)
