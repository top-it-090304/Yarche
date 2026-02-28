extends Node
@onready var computer_enemy: CharacterBody2D = $computer_enemy
@onready var green_player: CharacterBody2D = $CharacterBody2D

func _ready():
	green_player.set_min_speed(computer_enemy.speed)
	green_player.speed = green_player.MIN_SPEED
func _process(delta):
	if computer_enemy.global_position.x > 1500:
		computer_enemy.global_position.x = -150
	if green_player.global_position.x > 1500:
		green_player.global_position.x = -150
