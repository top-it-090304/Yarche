extends Area2D

func _ready():
	randomize()
	blink()

func blink():
	$Blick.visible = true
	var tween = create_tween()
	tween.tween_property($Blick, "modulate:a", 1.0, 0.3)
	tween.tween_property($Blick, "modulate:a", 0.0, 0.3)
	tween.tween_callback(func(): $Blick.visible = false)
	tween.tween_callback(func(): 
		await get_tree().create_timer(randf_range(1.0, 3.0)).timeout
		blink()
	)
