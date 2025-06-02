extends Node2D

@export var texture_normal_link: String = ''
@export var texture_pressed_link: String =  ''
@export var planet_name: String = ''
@export var planet_color: String = ''


var price: float

func _ready() -> void:
	price = GameState.PLANET_PRICE[planet_name]
	if texture_normal_link != '':
		$PlanetTexture.texture_normal = load(texture_normal_link)
	if texture_pressed_link != '':
		$PlanetTexture.texture_pressed = load(texture_pressed_link)
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
	#EventBus.planet_purchased.connect()

func _on_point_changed(new_point: float):
	var price = GameState.PLANET_PRICE[planet_name]
	if (new_point < price):
		$"Buy Overlay/Price".add_theme_color_override("default_color", Color.RED)
	else:
		$"Buy Overlay/Price".add_theme_color_override("default_color", Color.YELLOW)

func _unset_buy_overlay() -> void:
	$PlanetTexture.modulate = Color(1, 1, 1, 1)
	$PlanetTexture.mouse_filter = 0
	$"Buy Overlay".hide()

func _set_buy_overlay() -> void:
	$PlanetTexture.modulate = Color(0.3, 0.3, 0.3, 1.0)
	$PlanetTexture.mouse_filter = 2
	$"Buy Overlay".show()

func _on_planet_rotation_timer_timeout() -> void:
	$"PlanetTexture".rotation_degrees += 0.5

func _on_planet_texture_pressed() -> void:
	EventBus.planet_clicked.emit()

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
