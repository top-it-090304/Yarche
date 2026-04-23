extends Node
@onready var turtle: RigidBody2D = $turtle


func _ready():
	set_aim()
	
func set_aim():
	var objects = get_children()
	
	for obj in objects:
		if obj.is_in_group("mine"):
			obj.set_move_dir(turtle)
