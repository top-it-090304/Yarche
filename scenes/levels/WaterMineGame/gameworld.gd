extends Node
@onready var marker: Marker2D = $Marker2D

func _ready():
	set_aim()
	
func set_aim():
	var mines = get_children()
	
	for mine in mines:
		if mine is RigidBody2D:
			mine.set_move_dir(marker)
