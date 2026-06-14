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

# Purchasable shop items that have a 3D model to plant on the planet surface,
# keyed by planet name then by the item's display name. When an item is first
# bought its model is spawned on the spinning sphere.
const BUILDING_MODELS := {
	"Sun": {
		"Thermal Reactor": "res://assets/planets/sun/thermal-reactor-3d.fbx",
		"Atomic Circuitry": "res://assets/planets/sun/atomic-circulatory-3d.fbx",
		"Dyson Sphere": "res://assets/planets/sun/dyson-sphere-3d.fbx",
		"Fusion Energy": "res://assets/planets/sun/fusion-energy-3d.fbx",
	},
	"Earth": {
		"Campfire": "res://assets/planets/earth/fire-3d.fbx",
		"Farm": "res://assets/planets/earth/farm-3d.fbx",
		"Animal Farm": "res://assets/planets/earth/animal-farm-3d.fbx",
		"Windmill": "res://assets/planets/earth/windmill-3d.glb",
		"Factory": "res://assets/planets/earth/factory-3d.fbx",
	},
	"Jupiter": {
		"Steam Engine": "res://assets/planets/jupiter/steam-engine-3d.fbx",
		"Hydrogen Fusion Reactor": "res://assets/planets/jupiter/hydrogen-fusion-reactor-3d.fbx",
		"Helium Fusion Energy": "res://assets/planets/jupiter/helium-fusion-energy-3d.fbx",
		"Solar Radiation": "res://assets/planets/jupiter/solar-radiation-3d.fbx",
		"Thermal Radiation": "res://assets/planets/jupiter/thermal-radiation-3d.fbx",
	},
	"Mercury": {
		"Iron Factory": "res://assets/planets/mercury/iron-factory-3d.fbx",
		"Nickel Mine": "res://assets/planets/mercury/nickel-mine-3d.fbx",
		"Coal Power Plant": "res://assets/planets/mercury/coal-power-plan-3d.fbx",
		"Grey Matter": "res://assets/planets/mercury/grey-matter-3d.fbx",
		"Grey Matter Generator": "res://assets/planets/mercury/grey-matter-generator-3d.fbx",
	},
	"Saturn": {
		"Gas Powered Energy": "res://assets/planets/saturn/gas-powered-energy-3d.fbx",
		"Helium Mining": "res://assets/planets/saturn/helium-mining-3d.fbx",
		"Rhea Moon Mining": "res://assets/planets/saturn/rhea-moon-mining-3d.fbx",
		"Pressure Generator": "res://assets/planets/saturn/pressure-generator-3d.fbx",
	},
	"Neptune": {
		"Methane Burning": "res://assets/planets/neptune/methane-burning-3d.fbx",
		"Cyber Fusion": "res://assets/planets/neptune/cyber-fusion-3d.fbx",
		"Alien Energy": "res://assets/planets/neptune/alien-energy-3d.fbx",
	},
	"Mars": {
		"Solar Panels": "res://assets/planets/mars/solar-panel-3d.fbx",
		"Oil Mine": "res://assets/planets/mars/oil-mine-3d.fbx",
		"Coal Power Plant": "res://assets/planets/mars/coal-power-plan-3d.fbx",
		"Nuclear Power Plant": "res://assets/planets/mars/nuclear-power-plan-3d.fbx",
		"Marsian Technology": "res://assets/planets/mars/marsian-technology-3d.fbx",
	},
	"Venus": {
		"Thermal Energy": "res://assets/planets/venus/therma-energy-3d.fbx",
		"Atmosphere Generator": "res://assets/planets/venus/atmosphere-generator-3d.fbx",
		"Oxygen Creator": "res://assets/planets/venus/oxygen-creator-3d.fbx",
		"Alien Tech": "res://assets/planets/venus/alien-tech-3d.fbx",
	},
}

# Fixed spot on the unit sphere (direction from the centre) for each building so
# they spread across the front hemisphere without overlapping. Item names are
# unique across planets, so a single flat map is unambiguous.
const BUILDING_PLACEMENT := {
	# Earth
	"Campfire": Vector3(0.20, 0.30, 1.0),
	"Farm": Vector3(-0.60, 0.15, 0.80),
	"Animal Farm": Vector3(0.70, -0.20, 0.70),
	"Windmill": Vector3(-0.25, 0.70, 0.55),
	"Factory": Vector3(0.55, 0.45, 0.70),
	# Jupiter
	"Steam Engine": Vector3(0.20, 0.30, 1.0),
	"Hydrogen Fusion Reactor": Vector3(-0.60, 0.15, 0.80),
	"Helium Fusion Energy": Vector3(0.70, -0.20, 0.70),
	"Solar Radiation": Vector3(-0.25, 0.70, 0.55),
	"Thermal Radiation": Vector3(0.55, 0.45, 0.70),
	# Mercury
	"Iron Factory": Vector3(0.20, 0.30, 1.0),
	"Nickel Mine": Vector3(-0.60, 0.15, 0.80),
	"Coal Power Plant": Vector3(0.70, -0.20, 0.70),
	"Grey Matter": Vector3(-0.25, 0.70, 0.55),
	"Grey Matter Generator": Vector3(0.55, 0.45, 0.70),
	# Saturn
	"Gas Powered Energy": Vector3(0.20, 0.30, 1.0),
	"Helium Mining": Vector3(-0.60, 0.15, 0.80),
	"Rhea Moon Mining": Vector3(0.70, -0.20, 0.70),
	"Pressure Generator": Vector3(-0.25, 0.70, 0.55),
	# Neptune
	"Methane Burning": Vector3(0.20, 0.30, 1.0),
	"Cyber Fusion": Vector3(-0.60, 0.15, 0.80),
	"Alien Energy": Vector3(0.70, -0.20, 0.70),
	# Mars ("Coal Power Plant" reuses the shared entry above)
	"Solar Panels": Vector3(0.20, 0.30, 1.0),
	"Oil Mine": Vector3(-0.60, 0.15, 0.80),
	"Nuclear Power Plant": Vector3(-0.25, 0.70, 0.55),
	"Marsian Technology": Vector3(0.55, 0.45, 0.70),
	# Venus
	"Thermal Energy": Vector3(0.20, 0.30, 1.0),
	"Atmosphere Generator": Vector3(-0.60, 0.15, 0.80),
	"Oxygen Creator": Vector3(0.70, -0.20, 0.70),
	"Alien Tech": Vector3(-0.25, 0.70, 0.55),
}

# Some "planets" host spacecraft instead of ground structures: the Sun's
# technologies are vessels, so they orbit the star rather than sit on it. Each
# craft's orbit is themed to its name (see below). Keyed planet -> item -> params:
#   radius   distance from the star centre (local units)
#   speed    orbital angular speed (rad/s; sign sets direction)
#   phase    starting angle so craft don't bunch up
#   incline  tilt of the orbital plane (deg): 0 = edge-on (passes in front/behind
#            the star), 90 = face-on to the camera (a flat ring around it)
const ORBIT_CONFIG := {
	"Sun": {
		# Steady mid orbit.
		"Thermal Reactor": {"radius": 0.92, "speed": 0.30, "phase": 0.0, "incline": 78.0},
		# Atomic = a faster, tighter orbit, like an electron whipping round the nucleus.
		"Atomic Circuitry": {"radius": 0.80, "speed": 0.75, "phase": 2.0, "incline": 96.0},
		# A Dyson sphere encloses the star: the largest, slowest, encircling orbit.
		"Dyson Sphere": {"radius": 1.05, "speed": 0.12, "phase": 4.0, "incline": 60.0},
		# Energetic, steeply inclined pass that dives in front of and behind the star.
		"Fusion Energy": {"radius": 0.96, "speed": 0.45, "phase": 5.2, "incline": 42.0},
	},
}

# Radius of the normalized SphereMesh and the uniform longest-side every building
# is scaled to, both in the planet's local units. Orbiting craft are scaled to a
# larger size so they read clearly out at their orbit distance.
const PLANET_RADIUS := 0.5
const BUILDING_TARGET_SIZE := 0.16
const ORBITAL_TARGET_SIZE := 0.30

# Pull the camera back on orbital planets so there's room to see the craft circle
# at a comfortable distance from the star.
const ORBITAL_CAMERA_Z := 4.2
const DEFAULT_CAMERA_Z := 2.2

var price: float
var planet_view: Sprite2D
var _click_tween: Tween
var _planet3d: Node3D
var _placed_buildings: Dictionary = {}
var _orbit_root: Node3D
var _orbiters: Array = []
var _orbit_time: float = 0.0


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
	EventBus.item_purchased.connect(_on_item_purchased)
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
	camera.position = Vector3(0.0, 0.0, ORBITAL_CAMERA_Z if _is_orbital() else DEFAULT_CAMERA_Z)
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

	# Orbiting craft live in their own root at the star centre (the origin), kept
	# out of the pivot so the planet's spin/tilt doesn't drag their orbits around.
	_orbit_root = Node3D.new()
	viewport.add_child(_orbit_root)

	var packed_scene: PackedScene = load(scene_path)
	var planet3d := packed_scene.instantiate()
	planet3d.transform = Transform3D.IDENTITY  # normalize the preset's huge baked scale
	pivot.add_child(planet3d)
	_planet3d = planet3d

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

	# Re-plant the buildings for everything already owned so they persist when the
	# player leaves this planet and comes back.
	_populate_buildings()


# Adds a building for every shop item on this planet that the player already owns.
func _populate_buildings() -> void:
	var models: Dictionary = BUILDING_MODELS.get(planet_name, {})
	if models.is_empty():
		return
	for item in GameState.SHOP_ITEM_PLANET.get(planet_name, []):
		if models.has(item.name) and GameState.item_count.get(item, 0) >= 1:
			_add_building(item.name)


# True for planets whose technologies are spacecraft that orbit rather than sit
# on the surface (currently the Sun).
func _is_orbital() -> bool:
	return ORBIT_CONFIG.has(planet_name)


# Plants a single item's 3D model: on the surface for ground tech, or into orbit
# for spacecraft. Idempotent: one that's already there is left untouched.
func _add_building(item_name: String) -> void:
	if _planet3d == null or _placed_buildings.has(item_name):
		return
	var models: Dictionary = BUILDING_MODELS.get(planet_name, {})
	var model_path: String = models.get(item_name, "")
	if model_path == "":
		return

	var model: Node3D = load(model_path).instantiate()

	# Uniform sizing: scale so the model's longest side matches every other one of
	# its kind (surface buildings share one size, orbiting craft a larger one).
	var aabb := _local_aabb(model)
	var longest: float = max(aabb.size.x, max(aabb.size.y, aabb.size.z))
	var target: float = ORBITAL_TARGET_SIZE if _is_orbital() else BUILDING_TARGET_SIZE
	var scale_factor: float = target / longest if longest > 0.0 else 1.0
	model.scale = Vector3.ONE * scale_factor

	if _is_orbital():
		_add_orbiter(item_name, model, aabb, scale_factor)
	else:
		_add_surface_building(item_name, model, aabb, scale_factor)

	_play_model_animation(model)


# Sits the model's base centred on its anchor point, anchored upright on the
# surface and parented to the planet root so it spins along with the planet.
func _add_surface_building(item_name: String, model: Node3D, aabb: AABB, scale_factor: float) -> void:
	var base_centre := Vector3(
		aabb.position.x + aabb.size.x * 0.5,
		aabb.position.y,
		aabb.position.z + aabb.size.z * 0.5)
	model.position = -base_centre * scale_factor

	var normal: Vector3 = BUILDING_PLACEMENT.get(item_name, Vector3.BACK).normalized()
	var anchor := Node3D.new()
	anchor.transform = Transform3D(_surface_basis(normal), normal * PLANET_RADIUS)
	anchor.add_child(model)
	_planet3d.add_child(anchor)
	_placed_buildings[item_name] = anchor


# Centres the craft on its own centroid and registers an orbit for it. The actual
# position/heading is driven every frame in _process.
func _add_orbiter(item_name: String, model: Node3D, aabb: AABB, scale_factor: float) -> void:
	var centroid := aabb.position + aabb.size * 0.5
	model.position = -centroid * scale_factor

	var anchor := Node3D.new()
	anchor.add_child(model)
	_orbit_root.add_child(anchor)
	_placed_buildings[item_name] = anchor

	var cfg: Dictionary = ORBIT_CONFIG[planet_name][item_name]
	var inc: float = deg_to_rad(cfg.incline)
	# Two orthonormal axes spanning the (tilted) orbital plane.
	var u := Vector3(1.0, 0.0, 0.0)
	var v := Vector3(0.0, sin(inc), cos(inc))
	_orbiters.append({
		"node": anchor,
		"radius": cfg.radius,
		"speed": cfg.speed,
		"phase": cfg.phase,
		"u": u,
		"v": v,
		"normal": u.cross(v).normalized(),
	})


func _process(delta: float) -> void:
	if _orbiters.is_empty():
		return
	_orbit_time += delta
	for o in _orbiters:
		var a: float = o.phase + o.speed * _orbit_time
		var pos: Vector3 = (cos(a) * o.u + sin(a) * o.v) * o.radius
		var vel: Vector3 = -sin(a) * o.u + cos(a) * o.v
		o.node.transform = Transform3D(_heading_basis(vel, o.normal), pos)


# Orthonormal basis that points the craft's nose along its velocity (the models
# face +Z, so we align that with the travel direction), with the orbital plane's
# normal as up, so it banks the way it's travelling.
func _heading_basis(velocity: Vector3, up_hint: Vector3) -> Basis:
	var forward := velocity.normalized()
	var up := up_hint.normalized()
	var right := up.cross(forward)
	if right.length() < 0.001:
		right = Vector3.RIGHT
	right = right.normalized()
	var up2 := forward.cross(right).normalized()
	# 180° yaw from the -Z-forward convention so the model's +Z nose leads.
	return Basis(-right, up2, forward)


# Orthonormal basis whose +Y axis is the given surface normal.
func _surface_basis(normal: Vector3) -> Basis:
	var reference := Vector3.UP if absf(normal.dot(Vector3.UP)) < 0.99 else Vector3.RIGHT
	var tangent := reference.cross(normal).normalized()
	var bitangent := normal.cross(tangent).normalized()
	return Basis(tangent, normal, bitangent)


# Axis-aligned bounds of a model in its own local space (root transform ignored
# since we drive the root's scale/position ourselves).
func _local_aabb(model: Node) -> AABB:
	var corners: Array = []
	_collect_corners(model, Transform3D.IDENTITY, true, corners)
	if corners.is_empty():
		return AABB(Vector3.ZERO, Vector3.ONE)
	var aabb := AABB(corners[0], Vector3.ZERO)
	for c in corners:
		aabb = aabb.expand(c)
	return aabb


func _collect_corners(node: Node, parent_xform: Transform3D, is_root: bool, corners: Array) -> void:
	var xform := parent_xform
	if node is Node3D and not is_root:
		xform = parent_xform * node.transform
	if node is VisualInstance3D:
		var box: AABB = node.get_aabb()
		for i in 8:
			var corner := box.position + Vector3(
				box.size.x if i & 1 else 0.0,
				box.size.y if i & 2 else 0.0,
				box.size.z if i & 4 else 0.0)
			corners.append(xform * corner)
	for child in node.get_children():
		_collect_corners(child, xform, false, corners)


# Loops the model's first animation if it has one (fire flicker, windmill spin…).
func _play_model_animation(model: Node) -> void:
	var anim_player := _find_animation_player(model)
	if anim_player == null:
		return
	var names := anim_player.get_animation_list()
	if names.is_empty():
		return
	var anim := anim_player.get_animation(names[0])
	anim.loop_mode = Animation.LOOP_LINEAR
	anim_player.play(names[0])


func _find_animation_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node
	for child in node.get_children():
		var found := _find_animation_player(child)
		if found:
			return found
	return null


func _on_item_purchased(item: Item) -> void:
	# First purchase plants the building; later purchases are no-ops thanks to the
	# guard inside _add_building.
	var models: Dictionary = BUILDING_MODELS.get(planet_name, {})
	if models.has(item.name):
		_add_building(item.name)


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
