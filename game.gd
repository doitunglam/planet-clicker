extends Node2D

var redundant_point = 0

var planet : Node2D

func _add_point_per_second(value: float) -> void:
	GameState._add_point_per_second(value)

func _ready() -> void:	
	EventBus.item_purchase.connect(_on_item_purchase)
	EventBus.planet_change.connect(_on_planet_change)
	EventBus.planet_clicked.connect(_on_planet_texture_pressed)
	EventBus.point_changed.connect(_on_point_changed)
	EventBus.multiplier_changed.connect(_on_multiplier_changed)
	_set_arrow_visibility()
	_set_planet_name()
	_set_planet()
	
	var player = AudioStreamPlayer.new()
	var bg_music = preload("res://assets/sounds/space-ambience.mp3")
	player.stream = bg_music
	player.bus = "Master"
	add_child(player)
	player.volume_db = -20
	player.play()

func _on_point_changed(point: float):
	if point > GameState.highscore:
		GameState.highscore *= 10
		var timer = Timer.new()
		var firework = preload("res://fireworks.tscn").instantiate()
		GameState.highscore = GameState.highscore * 10
		$"./UI".add_child(firework)
		await get_tree().create_timer(5.0).timeout
		firework.queue_free()

func _on_item_purchase(item: Item, price: Array) -> void:
	GameState._add_point(-price[0])
	GameState._add_energy(-price[1])
	
	var buy_sound = preload("res://assets/sounds/cha_ching.mp3")
	play_sound_effect(buy_sound)
	if (item.effect_type == "passive"):
		_add_point_per_second(item.effect_value)
		
	if (item.effect_type == "active"):
		GameState.point_per_click_exp += 1
	GameState.add_item(item)
	
func _on_timer_timeout() -> void:
	var increase_point = GameState.point_per_second * 0.1*GameState.multiplier+ redundant_point
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
		planet.planet_color = GameState.PLANET_COLOR[GameState.PLANETS[GameState.current_planet_index]]
		planet.texture_normal_link = GameState.PLANET_IMG[GameState.PLANETS[GameState.current_planet_index]]["normal"]
		planet.texture_pressed_link = GameState.PLANET_IMG[GameState.PLANETS[GameState.current_planet_index]]["pressed"]
		planet.position = Vector2(832.0, 352.0)
		$UI.add_child(planet)
	else:
		var new_planet = planet_template.instantiate()
		new_planet.planet_name = GameState.PLANETS[GameState.current_planet_index]
		new_planet.planet_color = GameState.PLANET_COLOR[GameState.PLANETS[GameState.current_planet_index]]
		new_planet.texture_normal_link = GameState.PLANET_IMG[GameState.PLANETS[GameState.current_planet_index]]["normal"]
		new_planet.texture_pressed_link = GameState.PLANET_IMG[GameState.PLANETS[GameState.current_planet_index]]["pressed"]

		if direction == "right":
			new_planet.position = Vector2(get_viewport().size.x+200, 352.0)
		else:
			new_planet.position = Vector2(-get_viewport().size.x-200, 352.0)
		
		var tween = create_tween()
		$UI.add_child(new_planet)
		tween.tween_property(planet, "position", Vector2(get_viewport().size.x + 200 if direction == "left" else -get_viewport().size.x - 200, 352), 0.2)
		tween.tween_property(new_planet, "position", Vector2(832.0, 352.0), 0.3)

		var old_planet = planet
		planet = new_planet
		await tween.finished
		EventBus.planet_changed.emit(direction)
		old_planet.queue_free()

func _on_planet_change(direction: String) -> void:
	_set_planet(direction)
	_set_arrow_visibility()
	_set_planet_name()

func _on_debounce_timer_timeout() -> void:
	debouncing = false

@onready var flying_text_scene = preload("res://flying_text.tscn")
func _on_planet_texture_pressed() -> void:
	var player = AudioStreamPlayer.new()
	var bg_music = preload("res://assets/sounds/sci-fi-button-click.mp3")
	play_sound_effect(bg_music)
	var mouse_pos = get_viewport().get_mouse_position()
	if randf() < 0.05:  # 5% chance
		GameState._add_point(10*pow(2,GameState.point_per_click_exp)*GameState.multiplier)
		# Spawn 10 flying texts in random directions
		var radius = 80.0
		for i in range(10):
			var angle = 2 * PI * i / 10.0  # TAU = 2π
			var offset = Vector2(cos(angle), sin(angle)) * radius
			var text = flying_text_scene.instantiate()
			text.setup(mouse_pos + offset)
			$"./UI".add_child(text)
	else:
		GameState._add_point(pow(2,GameState.point_per_click_exp)*GameState.multiplier)
		var text = flying_text_scene.instantiate()
		text.setup(mouse_pos)
		$"./UI".add_child(text)

func play_sound_effect(stream: AudioStream):
	var player = AudioStreamPlayer.new()
	player.stream = stream
	player.bus = "Sound Effect"
	add_child(player)
	player.volume_db = -20
	player.play()
	# Free the player after the sound finishes
	player.connect("finished", player.queue_free)


func _on_free_resource_button_pressed() -> void:
	var overlay = preload("res://energy_gain_popup.tscn").instantiate()
	$"./UI".add_child(overlay)


func _on_free_2x_button_pressed() -> void:
	var overlay = preload("res://double_up.tscn").instantiate()
	$"./UI".add_child(overlay)
	
func _on_multiplier_changed() -> void:
	var label = $"UI/Double Label"
	var tween = create_tween()
	
	if GameState.multiplier == 1.0:
		tween.tween_property(label, "modulate:a", 0.0, 0.6)  # Fade out over 0.5s
		await tween.finished
		label.hide()
	else:
		tween.tween_property(label, "modulate:a", 1.0, 0.6)  # Fade in over 0.3s
		label.show()
