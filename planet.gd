extends Node2D

@export var texture_normal_link: String = ''
@export var texture_pressed_link: String =  ''
@export var planet_name: String = ''
@export var planet_color: String = ''

# Visible spin speed of the 3D planet. The preset's built-in rotation track is one
# full turn over 60s; this scales it, so a value of 3.0 gives one revolution per 20s.
@export var spin_speed: float = 3.0

# Maps each game planet to a naejimer_3d_planet_generator preset scene.
const GEN := "res://addons/naejimer_3d_planet_generator/scenes/"
const PLANET_SCENE := {
	"Sun": GEN + "star.tscn",
	"Mercury": GEN + "planet_no_atmosphere.tscn",
	"Venus": GEN + "planet_sand.tscn",
	"Earth": GEN + "planet_terrestrial.tscn",
	"Mars": GEN + "planet_lava.tscn",
	"Jupiter": GEN + "planet_gaseous.tscn",
	"Saturn": GEN + "planet_gaseous.tscn",
	"Neptune": GEN + "planet_ice.tscn",
}

var price: float
var planet_view: Sprite2D
var _click_tween: Tween


func _ready() -> void:
	price = GameState.PLANET_PRICE[planet_name]

	# The planet is now a real 3D sphere from the naejimer_3d_planet_generator,
	# rendered through a SubViewport and shown inside the 2D UI. The TextureButton
	# is kept (without a texture) purely as the click/input layer so buying and
	# clicking still work and all UI stays aligned.
	$PlanetTexture.texture_normal = null
	$PlanetTexture.texture_pressed = null
	_build_planet_3d()

	if planet_name != '':
		$"Buy Overlay/Price".parse_bbcode('%s[img]res://assets/icons/point_small.png[/img]' % GameState.format_number(price))

	var planet_background = preload("res://planet_background.tscn").instantiate()
	add_child(planet_background)

	if GameState.purchased_planet.has(planet_name):
		_unset_buy_overlay()
	else:
		_set_buy_overlay()
	EventBus.point_changed.connect(_on_point_changed)
	_on_point_changed(GameState.point)


func _build_planet_3d() -> void:
	var scene_path: String = PLANET_SCENE.get(planet_name, PLANET_SCENE["Earth"])

	# Offscreen 3D render target with its own isolated world.
	var viewport := SubViewport.new()
	viewport.size = Vector2i(320, 320)
	viewport.transparent_bg = true
	viewport.own_world_3d = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.msaa_3d = Viewport.MSAA_4X
	add_child(viewport)

	# Soft ambient light so the planet's night side isn't pure black.
	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.45, 0.5, 0.65)
	env.ambient_light_energy = 0.35
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	viewport.add_child(world_env)

	var camera := Camera3D.new()
	camera.fov = 30.0
	camera.position = Vector3(0.0, 0.0, 2.2)
	camera.current = true
	viewport.add_child(camera)

	# Directional key light produces the day/night terminator.
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-25.0, -35.0, 0.0)
	light.light_energy = 1.5
	viewport.add_child(light)

	# A tilted pivot gives the spinning planet a natural axial tilt.
	var pivot := Node3D.new()
	pivot.rotation_degrees = Vector3(0.0, 0.0, 18.0)
	viewport.add_child(pivot)

	var packed_scene: PackedScene = load(scene_path)
	var planet3d := packed_scene.instantiate()
	planet3d.transform = Transform3D.IDENTITY  # normalize the preset's huge baked scale
	pivot.add_child(planet3d)

	# Drive the built-in rotation animation. The preset ships with the spin scaled
	# down to 0.08 (one turn every ~750s, basically invisible), so bump it up to a
	# speed that actually reads as a spinning planet.
	var anim_tree: AnimationTree = planet3d.get_node_or_null("AnimationTree")
	if anim_tree:
		anim_tree.active = true
		anim_tree.set("parameters/TimeScale/scale", spin_speed)

	# Show the rendered sphere where the old 2D planet sat (the Planet origin).
	planet_view = Sprite2D.new()
	planet_view.texture = viewport.get_texture()
	planet_view.z_index = 0
	add_child(planet_view)


func _on_point_changed(new_point: float):
	var price = GameState.PLANET_PRICE[planet_name]
	if (new_point < price):
		$"Buy Overlay/Price".add_theme_color_override("default_color", Color.RED)
	else:
		$"Buy Overlay/Price".add_theme_color_override("default_color", Color.YELLOW)

func _unset_buy_overlay() -> void:
	if planet_view:
		planet_view.modulate = Color(1, 1, 1, 1)
	$PlanetTexture.mouse_filter = 0
	$"Buy Overlay".hide()

func _set_buy_overlay() -> void:
	if planet_view:
		planet_view.modulate = Color(0.3, 0.3, 0.3, 1.0)
	$PlanetTexture.mouse_filter = 2
	$"Buy Overlay".show()

func _on_planet_rotation_timer_timeout() -> void:
	# The 3D planet rotates via its own AnimationTree; no flat spin needed.
	pass

func _on_planet_texture_pressed() -> void:
	_play_click_effect()
	EventBus.planet_clicked.emit()

func _play_click_effect() -> void:
	# Quick "punch": squash the planet slightly, then spring back so each click
	# gives satisfying tactile feedback.
	if planet_view == null:
		return
	if _click_tween and _click_tween.is_running():
		_click_tween.kill()
	planet_view.scale = Vector2.ONE
	_click_tween = create_tween()
	_click_tween.tween_property(planet_view, "scale", Vector2(0.88, 0.88), 0.06) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_click_tween.tween_property(planet_view, "scale", Vector2.ONE, 0.28) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_buy_button_pressed() -> void:
	if GameState.point > price:
		GameState._add_point(-price)
		GameState.add_planet(planet_name)
		var buy_sound = preload("res://assets/sounds/cha_ching.mp3")
		play_sound_effect(buy_sound)
		_unset_buy_overlay()

func play_sound_effect(stream: AudioStream):
	var player = AudioStreamPlayer.new()
	player.stream = stream
	player.bus = "Sound Effect"
	add_child(player)
	player.volume_db = -20
	player.play()
	# Free the player after the sound finishes
	player.connect("finished", player.queue_free)
