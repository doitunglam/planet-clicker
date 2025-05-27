extends ColorRect

var item: Item
var price: float

var planet_purchased = false
func _ready():
	planet_purchased = GameState.purchased_planet.has(GameState.PLANETS[GameState.current_planet_index])
	price = GameState.calulate_price(item)
	var icon = load(item.icon_path)

	$"Name".text = item.name
	$Effect.bbcode_enabled = true
	$Icon.texture = icon
	if item.effect_type == "passive":
		$"Effect".parse_bbcode('produces %s [img]res://assets/icons/point_small.png[/img] per second' % GameState.format_number(item.effect_value) )
	else:
		$Effect.parse_bbcode("makes your click 2 times as powerful")
	$"Price".text = GameState.format_number(price)
	EventBus.item_purchased.connect(_on_item_purchased)
	EventBus.point_changed.connect(_on_point_changed)
	EventBus.planet_purchased.connect(_on_planet_purchased)

func _on_planet_purchased(planet: String):
	planet_purchased = true

func _on_point_changed(new_point) -> void:
	if planet_purchased and new_point >= price:
		$"Disable Overlay".hide()
		$Price.add_theme_color_override("default_color", Color.YELLOW)
	else:
		$"Disable Overlay".show()
		$Price.add_theme_color_override("default_color", Color.RED)

func _on_item_purchased(target_item: Item) -> void:
	if (item.name == target_item.name) or (target_item.effect_type == "active" and item.effect_type == "active"):
		price = GameState.calulate_price(item)
		$"Price".text = GameState.format_number(price)
		if GameState.point >= price:
			$"Disable Overlay".hide()
			$Price.add_theme_color_override("default_color", Color.YELLOW)
		else:
			$"Disable Overlay".show()
			$Price.add_theme_color_override("default_color", Color.RED)
		
func _on_button_pressed() -> void:
	EventBus.item_purchase.emit(item)
