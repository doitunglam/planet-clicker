extends TextureButton

func _on_planet_rotation_timer_timeout() -> void:
	$".".rotation_degrees += 1

@onready var flying_text_scene = preload("res://flying_text.tscn")
func _on_planet_pressed() -> void:
	var text = flying_text_scene.instantiate()
	var mouse_pos = get_viewport().get_mouse_position()
	text.setup(mouse_pos)
	$'../.'.add_child(text)
	
	GameState._add_point(GameState.point_per_click)
