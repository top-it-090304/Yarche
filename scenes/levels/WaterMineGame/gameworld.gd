extends Node
@onready var turtle: RigidBody2D = $turtle
@onready var mines: Node = $mines
signal win
signal lose

func _ready():
	set_aim()
	
func set_aim():
	var mines_list = mines.get_children()
	
	for mine in mines_list:
		if mine.is_in_group("mine"):
			mine.set_move_dir(turtle)
			mine.deleted.connect(check_mines)
			
func check_mines():
	var mines_list = mines.get_children()
	print(mines_list.size())
	if mines_list.size() -1 == 0: 
		win.emit()
		print("ВЫиграли")
