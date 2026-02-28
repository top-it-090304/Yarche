extends Control
@onready var play_btn: TextureButton = $play
@onready var exit_btn: TextureButton = $exit
signal play_button_pressed

func _ready():
	exit_btn.pressed.connect(_on_exit_btn_pressed)
	play_btn.pressed.connect(_on_play_btn_pressed)
	
func _on_exit_btn_pressed():
	get_tree().quit()
func _on_play_btn_pressed():
	emit_signal("play_button_pressed")
