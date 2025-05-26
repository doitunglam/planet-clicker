extends Node2D

@export var text: String
func setup(position: Vector2):
	$"Message".parse_bbcode('+%s[img]res://assets/icons/point_small.png[/img]' % GameState.format_number(pow(2, GameState.point_per_click_exp)))
	global_position = position

	# Tween for motion + fade
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 50, 0.8)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.8)
	tween.tween_callback(queue_free)
