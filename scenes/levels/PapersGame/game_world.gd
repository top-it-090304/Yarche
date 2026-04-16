extends Node
var papers = []
var max_paper_count = 5
const PAPER = preload("res://scenes/objects/PapersGame/Paper/Paper.tscn")

func _ready():
	spawn_paper()
	
func _process(delta	):
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
		
	for paper in papers:
		if paper.movable == true:
			return
			
	spawn_paper()
