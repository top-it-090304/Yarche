extends Node2D

@onready var rod_handle = $RodHandle

var rod_min_y = -210.0   
var rod_max_y = -40.0
var rod_current_y = -125.0

var target_y = -125.0
var speed = 15.0

# Размеры только верхней части (ручки) - настройте визуально
var handle_height = 40  # Высота только ручки (верхней части)
var handle_width = 200   # Ширина ручки

# Для отслеживания позиции касания
var touch_start_y = 0.0
var rod_start_y = 0.0
var is_touching = false

func _ready():
	rod_handle.position.y = rod_current_y
	target_y = rod_current_y

func _process(delta):
	rod_handle.position.y = move_toward(rod_handle.position.y, target_y, speed * delta * 60)
	rod_current_y = rod_handle.position.y

func is_point_on_handle(point: Vector2) -> bool:
	# Получаем глобальную позицию ручки
	var handle_global_pos = rod_handle.global_position
	
	# Получаем полный размер текстуры
	var full_texture_size = rod_handle.texture.get_size() * rod_handle.scale
	
	# Вычисляем позицию только верхней части (ручки)
	# Предполагаем, что ручка находится в верхней части спрайта
	var handle_rect = Rect2(
		handle_global_pos.x - handle_width/2,  # Центрируем по X
		handle_global_pos.y - full_texture_size.y/2,  # Верхняя граница спрайта
		handle_width,
		handle_height
	)
	
	# Добавляем отступ для удобства касания
	handle_rect = handle_rect.grow(10)
	
	return handle_rect.has_point(point)

func start_touch(touch_pos: Vector2):
	is_touching = true
	touch_start_y = touch_pos.y
	rod_start_y = rod_current_y
	print("Начали касание ручки")

func update_touch_position(touch_pos: Vector2):
	if not is_touching:
		return
	
	var delta_y = touch_pos.y - touch_start_y
	var new_target = rod_start_y + delta_y * 0.5
	new_target = clamp(new_target, rod_min_y, rod_max_y)
	target_y = new_target
	
	# Давление добавляем при движении вниз
	if delta_y > 5:
		add_pressure_from_movement(delta_y)

func end_touch():
	is_touching = false

func add_pressure_from_movement(delta_y: float):
	var level = get_parent()
	if level and level.has_method("add_pressure"):
		level.add_pressure(delta_y * 0.001)

func get_pump_size() -> Vector2:
	# Возвращаем размер только ручки (для визуальной отладки)
	return Vector2(handle_width, handle_height)
