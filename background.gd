extends ColorRect

@export var star_count: int = 100
@export var star_min_size: int = 2
@export var star_max_size: int = 5

func _ready():
	create_static_stars(star_count)

func create_static_stars(count: int):
	for i in count:
		var star = ColorRect.new()
		var size = randi_range(star_min_size, star_max_size)
		star.color = Color(1, 1, 1, 1)
		star.size = Vector2(size, size)

		star.position = Vector2(
			randf() * get_window().size.x,
			randf() * get_window().size.y
		)
		star.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Let input pass through
		star.z_index = 0
		add_child(star)
