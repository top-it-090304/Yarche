extends Area2D
@export var texture_path: String = "res://assets/img/AvoidTheGarbage/screwdriver.png"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

func _setup_nodes():
	var texture: Texture2D = load(texture_path)
	sprite.texture = texture
	collision_shape.shape.size = texture.get_size()
	
func _ready():
	_setup_nodes()

func _process(delta: float) -> void:
	rotate(deg_to_rad(60)*delta)
