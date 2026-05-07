extends Area2D
@onready var label: RichTextLabel = $RichTextLabel
@onready var collision: CollisionShape2D = $collsion

var min_pos
var max_pos

var state
var movable = true
var is_dragging = false
var drag_offset

enum PaperState {
	RIGHT,
	WRONG
}
var data = [
	# ПРАВИЛЬНЫЕ (хорошие действия)
	{
		"text" : "Снизить налоги",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Помогать бедным",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Повышение прожиточного минимума",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Строить детские сады",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Бесплатная медицина",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Защищать природу",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Кормить бездомных",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Бесплатное образование",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Помогать пенсионерам",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Строить парки",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Спасать животных",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Чистить реки",
		"state": PaperState.RIGHT
	},
	
	# НЕПРАВИЛЬНЫЕ (плохие действия)
	{
		"text" : "Поддержать терроризм",
		"state": PaperState.WRONG
	},
	{
		"text" : "15% зарплаты в казино",
		"state": PaperState.WRONG
	},
	{
		"text" : "Власть у котиков",
		"state": PaperState.WRONG
	},
	{
		"text" : "Вырубить все леса",
		"state": PaperState.WRONG
	},
	{
		"text" : "Отменить школу",
		"state": PaperState.WRONG
	},
	{
		"text" : "Запретить мороженое",
		"state": PaperState.WRONG
	},
	{
		"text" : "Уволить всех врачей",
		"state": PaperState.WRONG
	},
	{
		"text" : "Сжечь книги",
		"state": PaperState.WRONG
	},
	{
		"text" : "Кормить детей жуками",
		"state": PaperState.WRONG
	},
	{
		"text" : "Заставить всех спать на полу",
		"state": PaperState.WRONG
	},
	{
		"text" : "Красть у стариков",
		"state": PaperState.WRONG
	},
	{
		"text" : "Отключить интернет",
		"state": PaperState.WRONG
	},
	{
		"text" : "Купить танк вместо больницы",
		"state": PaperState.WRONG
	},
	{
		"text" : "Сделать мышей президентами",
		"state": PaperState.WRONG
	},
	{
		"text" : "Отменить выходные",
		"state": PaperState.WRONG
	}
]
func _ready():
	animated_spawn()
	set_window_borders()
	set_random_state()
	
func set_random_state():
	var info = data.pick_random()
	label.text = info.text
	state = info.state

func _input(event):
	var finger_position = get_global_mouse_position()
	if not movable:
		return
		
	if event is InputEventScreenTouch:
		if event.pressed and is_finger_cover_paper(finger_position):
			start_drag(finger_position)
		else:
			stop_drag()
	elif event is InputEventScreenDrag and is_dragging:
		update_drag(finger_position)
		
	elif Input.is_action_just_pressed("ui_accept"):
		set_random_state()

func is_finger_cover_paper(pos):
	var size = collision.shape.size
	
	var is_inside = (pos >= global_position - size/2 and pos <= global_position + size/2)
	return is_inside
	
func start_drag(finger_position):
	is_dragging = true
	drag_offset = finger_position - global_position
	
	var animate_tween = create_tween().set_parallel(true)
	animate_tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.2)
	animate_tween.tween_property(self, "rotation", deg_to_rad(6), 0.2)
	$AudioStreamPlayer2D.play()
	
func update_drag(finger_position):
	var new_pos = finger_position - drag_offset
	global_position.x = clamp(new_pos.x, min_pos.x, max_pos.x)
	global_position.y = clamp(new_pos.y, min_pos.y, max_pos.y)
		
func stop_drag():
	is_dragging = false
	
	var animate_tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	animate_tween.tween_property(self, "scale", Vector2(1, 1), 0.2)
	animate_tween.tween_property(self, "rotation", deg_to_rad(0), 0.2)
	
func set_window_borders():
	var size = collision.shape.size
	
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
	
	# Получаем видимую область экрана в мировых координатах
	var screen_top_left = camera.get_screen_center_position() - get_viewport().get_visible_rect().size * camera.zoom / 2
	
	var screen_size = get_viewport().get_visible_rect().size * camera.zoom
	
	min_pos = screen_top_left + size / 2
	max_pos = screen_top_left + screen_size - size / 2

func _process(delta):
	# Проверяем каждый кадр, находится ли объект в правильной зоне
	var is_in_correct_zone = false
	
	for area in get_overlapping_areas():
		if (state == PaperState.RIGHT and area.is_in_group("true_area")) or (state == PaperState.WRONG and area.is_in_group("false_area")):
			is_in_correct_zone = true
			break
	
	# Если в правильной зоне и не перетаскивается - запрещаем движение
	if is_in_correct_zone and not is_dragging:
		if movable != false:  # Чтобы не спамить в консоль
			print("В правильной зоне! movable = false")
		movable = false
	else:
		if movable != true and not is_dragging:  # Чтобы не спамить в консоль
			print("Не в зоне или перетаскивается, movable = true")
		movable = true
func animated_spawn():
	scale = Vector2.ZERO
	var tween = create_tween().set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "scale", Vector2(1,1), 0.4)
