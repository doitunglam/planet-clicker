extends Node2D

var redundant_point = 0

var planet : Node2D

func _add_point_per_second(value: int) -> void:
	GameState._add_point_per_second(value)

func _ready() -> void:	
	EventBus.item_purchase.connect(_on_item_purchase)
	EventBus.planet_changed.connect(_on_planet_changed)
	EventBus.planet_purchase.connect(_on_planet_purchase)
	EventBus.planet_clicked.connect(_on_planet_texture_pressed)
	EventBus.point_changed.connect(_on_point_changed)
	_set_arrow_visibility()
	_set_planet_name()
	_set_planet()

func _on_point_changed(point: float):
	if point > GameState.highscore:
		var timer = Timer.new()
		var firework = preload("res://fireworks.tscn").instantiate()
		firework.position = Vector2(650, 750)
		GameState.highscore = GameState.highscore * 10
		$"./UI".add_child(firework)
		await get_tree().create_timer(5.0).timeout
		firework.queue_free()

func _on_item_purchase(item: Item) -> void:
	var item_price = GameState.calulate_price(item)
	
	if (GameState.point < item_price):
		return

	GameState._add_point(-item_price)
	
	var buy_sound = preload("res://assets/sounds/cha_ching.mp3")
	play_sound_effect(buy_sound)
	if (item.effect_type == "passive"):
		_add_point_per_second(item.effect_value)
		
	if (item.effect_type == "active"):
		GameState.point_per_click_exp += 1
	GameState.add_item(item)
	
func _on_planet_purchase(planet: String) -> void:
	var price = GameState.PLANET_PRICE[planet]
	if (GameState.point < price):
		return
	GameState._add_point(-price)
	GameState.add_planet(planet)
	EventBus.planet_purchased.emit(planet)
	
func _on_timer_timeout() -> void:
	var increase_point = GameState.point_per_second * 0.1 + redundant_point
	redundant_point = increase_point - increase_point
	
	GameState._add_point(increase_point)

var debouncing = false
func _on_move_to_left_pressed() -> void:
	if debouncing == false:
		GameState.change_planet("left")
		debouncing = true
		$"Debounce Timer".start()

func _on_move_to_right_pressed() -> void:
	if debouncing == false:
		GameState.change_planet("right")
		debouncing = true
		$"Debounce Timer".start()
		
func _set_planet_name() -> void:
	$"UI/Planet Name".text = GameState.PLANETS[GameState.current_planet_index].to_upper()

func _set_arrow_visibility() -> void:
	if (GameState.current_planet_index == 0):
		$"UI/Move To Left".hide()
		$"UI/Move To Right".show()
	elif (GameState.current_planet_index == GameState.PLANETS.size()-1):
		$"UI/Move To Left".show()
		$"UI/Move To Right".hide()
	else:
		$"UI/Move To Left".show()
		$"UI/Move To Right".show()

@onready var planet_template = preload("res://planet.tscn")
func _set_planet(direction: String = "") -> void:
	if (planet == null):
		planet = planet_template.instantiate()
		planet.planet_name = GameState.PLANETS[GameState.current_planet_index]
		planet.texture_normal_link = GameState.PLANET_IMG[GameState.PLANETS[GameState.current_planet_index]]["normal"]
		planet.texture_pressed_link = GameState.PLANET_IMG[GameState.PLANETS[GameState.current_planet_index]]["pressed"]
		planet.position = Vector2(832.0, 352.0)
		$UI.add_child(planet)
	else:
		var new_planet = planet_template.instantiate()
		new_planet.planet_name = GameState.PLANETS[GameState.current_planet_index]
		new_planet.texture_normal_link = GameState.PLANET_IMG[GameState.PLANETS[GameState.current_planet_index]]["normal"]
		new_planet.texture_pressed_link = GameState.PLANET_IMG[GameState.PLANETS[GameState.current_planet_index]]["pressed"]

		if direction == "right":
			new_planet.position = Vector2(get_viewport().size.x+100, 352.0)
		else:
			new_planet.position = Vector2(-get_viewport().size.x-100, 352.0)
		
		var tween = create_tween()
		$UI.add_child(new_planet)
		tween.tween_property(planet, "position", Vector2(get_viewport().size.x + 100 if direction == "left" else -get_viewport().size.x - 100, 352), 0.2)
		tween.tween_property(new_planet, "position", Vector2(832.0, 352.0), 0.3)

		var old_planet = planet
		planet = new_planet
		await tween.finished
		old_planet.queue_free()

func _on_planet_changed(direction: String) -> void:
	_set_arrow_visibility()
	_set_planet_name()
	_set_planet(direction)

func _on_debounce_timer_timeout() -> void:
	debouncing = false
	
@onready var flying_text_scene = preload("res://flying_text.tscn")
func _on_planet_texture_pressed() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	if randf() < 0.05:  # 5% chance
		GameState._add_point(10*pow(2,GameState.point_per_click_exp))
		# Spawn 10 flying texts in random directions
		var radius = 80.0
		for i in range(10):
			var angle = 2 * PI * i / 10.0  # TAU = 2π
			var offset = Vector2(cos(angle), sin(angle)) * radius
			var text = flying_text_scene.instantiate()
			text.setup(mouse_pos + offset)
			$"./UI".add_child(text)
	else:
		GameState._add_point(pow(2,GameState.point_per_click_exp))
		var text = flying_text_scene.instantiate()
		text.setup(mouse_pos)
		$"./UI".add_child(text)

func play_sound_effect(stream: AudioStream):
	var player = AudioStreamPlayer.new()
	player.stream = stream
	player.bus = "Sound Effect"
	add_child(player)
	player.play()
	# Free the player after the sound finishes
	player.connect("finished", player.queue_free)
