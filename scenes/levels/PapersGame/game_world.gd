extends Node
signal all_checked
var game_active = true
var papers = []
var max_paper_count = 5
const PAPER = preload("res://scenes/objects/PapersGame/Paper/Paper.tscn")
var data_queue = []
var data = [
	# ПРАВИЛЬНЫЕ (хорошие действия)
	{
		"text" : "Снизить налоги",
		"state": Paper.PaperState.RIGHT
	},
	{
		"text" : "Помогать бедным",
		"state": Paper.PaperState.RIGHT
	},
	{
		"text" : "Повышение прожиточного минимума",
		"state": Paper.PaperState.RIGHT
	},
	{
		"text" : "Строить детские сады",
		"state": Paper.PaperState.RIGHT
	},
	{
		"text" : "Бесплатная медицина",
		"state": Paper.PaperState.RIGHT
	},
	{
		"text" : "Защищать природу",
		"state": Paper.PaperState.RIGHT
	},
	{
		"text" : "Кормить бездомных",
		"state": Paper.PaperState.RIGHT
	},
	{
		"text" : "Бесплатное образование",
		"state": Paper.PaperState.RIGHT
	},
	{
		"text" : "Помогать пенсионерам",
		"state": Paper.PaperState.RIGHT
	},
	{
		"text" : "Строить парки",
		"state": Paper.PaperState.RIGHT
	},
	{
		"text" : "Спасать животных",
		"state": Paper.PaperState.RIGHT
	},
	{
		"text" : "Чистить реки",
		"state": Paper.PaperState.RIGHT
	},
	
	# НЕПРАВИЛЬНЫЕ (плохие действия)
	{
		"text" : "Поддержать терроризм",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "15% зарплаты в казино",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "Власть у котиков",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "Вырубить все леса",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "Отменить школу",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "Запретить мороженое",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "Уволить всех врачей",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "Сжечь книги",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "Кормить детей жуками",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "Заставить всех спать на полу",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "Красть у стариков",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "Отключить интернет",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "Купить танк вместо больницы",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "Сделать мышей президентами",
		"state": Paper.PaperState.WRONG
	},
	{
		"text" : "Отменить выходные",
		"state": Paper.PaperState.WRONG
	}
]
func _ready():
	
	data.shuffle()
	data_queue = data.slice(0,6)
	spawn_paper()
	
func _process(delta	):
	if game_active:
		check_papers()
	
func spawn_paper():
	if papers.size() >= max_paper_count:
		return
	
	var paper = PAPER.instantiate()
	paper.info = data_queue.pop_at(0)
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
	
