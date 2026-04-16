extends Node
signal all_checked
var game_active = true
var papers = []
var max_paper_count = 5
const PAPER = preload("res://scenes/objects/PapersGame/Paper/Paper.tscn")

func _ready():
	spawn_paper()
	
func _process(delta	):
	if game_active:
		check_papers()
	
func spawn_paper():
	if papers.size() >= max_paper_count:
		return
	
	var paper = PAPER.instantiate()
	paper.global_position = Vector2(1920/2,540)
	add_child(paper)
	
	papers.append(paper)
	
func check_papers():
	
	if papers.size() == 0:
		return
		
	var not_movable_cnt = 0
	for paper in papers:
		if paper.movable == false:
			not_movable_cnt +=1
			
	if not_movable_cnt == max_paper_count: 
		game_active = false
		print("выиграли")
		all_checked.emit()
	
	if not_movable_cnt == papers.size():
		spawn_paper()
	
