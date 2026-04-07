extends Node2D

@onready var rod_handle = $RodHandle
@onready var controlshape: CollisionShape2D = $RodHandle/ControlArea/ControlShape

var rod_min_y = -210.0   
var rod_max_y = -40.0
var rod_current_y = -125.0

var drag_target_y = -125.0

var touch_start_y = 0.0
var rod_start_y = 0.0
var is_touching = false
var active_touch_index = -1
var handle_tween: Tween

var total_movement = 0.0
var last_position_y = 0.0
var pump_cooldown = false
var pump_efficiency = 0.04

# Переменные для стравливания
var was_going_down = false
var leak_rate = 2.0            # Скорость стравливания в секунду
signal pump_stroke(amount: float)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	rod_handle.position.y = rod_current_y
	drag_target_y = rod_current_y
	last_position_y = rod_current_y
	print("[Pump] ready. process_mode=", process_mode)
	print("[Pump] controlshape=", controlshape)


func _process(delta):
	rod_current_y = rod_handle.position.y
	
	if is_touching:
		check_pump_movement()

func _input(event):
	var finger_position = get_global_mouse_position()
	if event is InputEventScreenTouch:
		print("[Pump] ScreenTouch pressed=", event.pressed, " index=", event.index, " finger=", finger_position)
		if event.pressed:
			var inside = is_point_inside_controlshape(finger_position)
			print("[Pump] touch inside controlshape=", inside)
			if inside:
				active_touch_index = event.index
				start_touch(finger_position)
		else:
			if event.index == active_touch_index:
				active_touch_index = -1
				end_touch()
				print("[Pump] touch ended for active index")
			else:
				print("[Pump] touch end ignored. active=", active_touch_index)
	elif event is InputEventScreenDrag and is_touching and event.index == active_touch_index:
		print("[Pump] ScreenDrag index=", event.index, " finger=", finger_position)
		update_touch_position(finger_position)

func is_point_inside_controlshape(point: Vector2) -> bool:
	if controlshape == null:
		print("[Pump] is_point_inside_controlshape: controlshape is null")
		return false
	
	var rect_shape = controlshape.shape as RectangleShape2D
	if rect_shape == null:
		print("[Pump] is_point_inside_controlshape: shape is not RectangleShape2D")
		return false
	var global_center = controlshape.global_position
	var half_size: Vector2 = rect_shape.size * 0.5
	var inside = (point.x >= global_center.x - half_size.x and
			point.x <= global_center.x + half_size.x and
			point.y >= global_center.y - half_size.y and
			point.y <= global_center.y + half_size.y)
	print("[Pump] hit test point=", point, " center=", global_center, " half=", half_size, " inside=", inside)
	
	return inside

func start_touch(touch_pos: Vector2):
	is_touching = true
	touch_start_y = touch_pos.y
	rod_start_y = rod_current_y
	last_position_y = rod_current_y
	total_movement = 0.0
	pump_cooldown = false
	was_going_down = false
	print("[Pump] start_touch pos=", touch_pos, " rod_start_y=", rod_start_y)

func update_touch_position(touch_pos: Vector2):
	if not is_touching:
		print("[Pump] update_touch_position ignored: not touching")
		return
	
	var delta_y = touch_pos.y - touch_start_y
	drag_target_y = clamp(rod_start_y + delta_y * 0.5, rod_min_y, rod_max_y)
	print("[Pump] drag pos=", touch_pos, " delta_y=", delta_y, " target_y=", drag_target_y)
	animate_handle_to(drag_target_y)

func end_touch():
	is_touching = false
	pump_cooldown = false
	print("[Pump] end_touch")

func check_pump_movement():
	var movement = rod_current_y - last_position_y
	
	if movement > 0.5:
		if not pump_cooldown:
			var pressure_amount = movement * pump_efficiency
			pressure_amount = clamp(pressure_amount, 0.01, 0.15)
			
			pump_stroke.emit(pressure_amount)
			print("[Pump] stroke emitted +", pressure_amount, " movement=", movement)
			
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

func animate_handle_to(new_y: float):
	if handle_tween:
		handle_tween.kill()
	handle_tween = create_tween()
	handle_tween.tween_property(rod_handle, "position:y", new_y, 0.08)
	print("[Pump] tween to y=", new_y)

func release_pressure(delta):
	var level = _find_parent_with_method("release_pressure")
	if level:
		var current_leak = leak_rate
		
		if is_touching:
			current_leak = leak_rate * 0.7
		level.release_pressure(delta * current_leak)

func _find_parent_with_method(method_name: String) -> Node:
	var current: Node = self
	while current:
		if current.has_method(method_name):
			return current
		current = current.get_parent()
	return null
