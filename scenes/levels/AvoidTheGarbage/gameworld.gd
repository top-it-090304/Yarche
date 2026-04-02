extends Node
@onready var cooldown_timer: Timer = $spawn_cooldown
var garbage_scene = preload("res://scenes/objects/Garbage/garbage.tscn")

var spawn_margin = 20
var spawn_offset = 60

var right_border_spawn
var left_border_spawn

var MAX_GARBAGE_CNT  = 5
var speed = 700
var garbage_list: Array
var x_spawns_list: Array
var down_border

var garbage_texture_paths = [
	"res://assets/img/AvoidTheGarbage/package.png",
	"res://assets/img/AvoidTheGarbage/screwdriver.png",
	"res://assets/img/AvoidTheGarbage/fork.png"
]

func _ready() -> void:
	right_border_spawn = get_viewport().size.x - spawn_margin
	left_border_spawn = spawn_margin
	down_border = get_viewport().size.y
	
	_create_x_spawns()
	
	cooldown_timer.wait_time = 1
	cooldown_timer.timeout.connect(_spawn_new_garbage)
	cooldown_timer.start()
	
func _spawn_new_garbage():
	if garbage_list.size() < MAX_GARBAGE_CNT:
		var garbage = garbage_scene.instantiate()
		garbage.texture_path = garbage_texture_paths.pick_random()
		var x_spawn_position = x_spawns_list.pick_random()
		garbage.global_position = Vector2(x_spawn_position, -200)
		garbage_list.append(garbage)
		add_child(garbage)
		
func _create_x_spawns():
	for x_pos in range(left_border_spawn, right_border_spawn, spawn_offset):
		x_spawns_list.append(x_pos)
		
func _move_garbages(delta):
	for garbage in garbage_list:
		garbage.position.y += speed*delta

func _check_garbages():
	for i in range(garbage_list.size()-1,-1,-1):
		var garbage = garbage_list[i]
		if garbage.position.y > down_border + 400:
			garbage.queue_free()
			garbage_list.pop_at(i)

func _process(delta):
	_move_garbages(delta)
	_check_garbages()
