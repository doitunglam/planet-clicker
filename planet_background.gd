extends Panel

@onready var stylebox = get_theme_stylebox("panel") as StyleBoxTexture
func _ready() -> void:
		# Create the gradient resource
	var gradient := Gradient.new()
	gradient.offsets = PackedFloat32Array([0.204918, 0.688525, 1])
	gradient.colors = PackedColorArray([
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0)
	])

	# Create the gradient texture
	var gradient_texture := GradientTexture2D.new()
	gradient_texture.gradient = gradient
	gradient_texture.fill = GradientTexture2D.FILL_RADIAL
	gradient_texture.fill_from = Vector2(0.5, 0.5)
	gradient_texture.fill_to = Vector2(0.9, 0.7)
	gradient_texture.width = 64
	gradient_texture.height = 64

	# Create the style box and assign the texture
	var stylebox := StyleBoxTexture.new()
	stylebox.texture = gradient_texture
	stylebox.modulate_color = Color(0.41, 0.41, 0.41, 1)
	var color = GameState.PLANET_COLOR[GameState.PLANETS[GameState.current_planet_index]]
	gradient.set_color(1, color)

	# Apply the style box as the panel's theme override
	add_theme_stylebox_override("panel", stylebox)
