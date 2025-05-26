extends Node2D

var redundant_point = 0

var planet : TextureButton

func _add_point_per_second(value: int) -> void:
	GameState._add_point_per_second(value)

func _ready() -> void:	
	EventBus.item_purchase.connect(_on_item_purchase)
	EventBus.planet_changed.connect(_on_planet_changed)
	_set_arrow_visibility()
	_set_planet_name()
	_set_planet()

func _on_item_purchase(item: Item) -> void:
	var item_price = GameState.calulate_price(item)
	
	if (GameState.point < item_price):
		return

	GameState._add_point(-item_price)

	if (item.effect_type == "passive"):
		_add_point_per_second(item.effect_value)
		
	if (item.effect_type == "active"):
		GameState.point_per_click_exp += 1
	GameState.add_item(item)
	
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
		planet.texture_normal = load(GameState.PLANET_IMG[GameState.PLANETS[GameState.current_planet_index]]["normal"])
		planet.texture_pressed = load(GameState.PLANET_IMG[GameState.PLANETS[GameState.current_planet_index]]["pressed"])
		planet.position = Vector2(736.0, 288.0)
		$UI.add_child(planet)
	else:
		var new_planet = planet_template.instantiate()
		new_planet.texture_normal = load(GameState.PLANET_IMG[GameState.PLANETS[GameState.current_planet_index]]["normal"])
		new_planet.texture_pressed = load(GameState.PLANET_IMG[GameState.PLANETS[GameState.current_planet_index]]["pressed"])
		if direction == "right":
			new_planet.position = Vector2(get_viewport().size.x+100, 288.0)
		else:
			new_planet.position = Vector2(-get_viewport().size.x-100, 288.0)
		
		var tween = create_tween()
		$UI.add_child(new_planet)
		tween.tween_property(planet, "position", Vector2(get_viewport().size.x + 100 if direction == "left" else -get_viewport().size.x - 100, 288), 0.2)
		tween.tween_property(new_planet, "position", Vector2(736.0, 288.0), 0.3)

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
