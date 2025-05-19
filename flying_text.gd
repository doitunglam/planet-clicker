extends Node2D

@onready var label = $Label
@export var text: String

func setup(text: String, position: Vector2):
	$Label.text = text
	global_position = position

	# Tween for motion + fade
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 50, 0.8)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.8)
	tween.tween_callback(queue_free)
