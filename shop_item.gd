extends ColorRect

var item: Item
var price: int

func _ready():
	price = GameState.calulate_price(item)
	$"Name".text = item.name
	$Effect.bbcode_enabled = true
	if item.effect_type == "passive":
		$"Effect".parse_bbcode('produces %d [img]res://assets/icons/point_small.png[/img] per second' % item.effect_value )
	else:
		$Effect.parse_bbcode("makes your click 2 times as powerfull")
	$"Price".text = str(price)
	EventBus.item_purchased.connect(_on_item_purchased)
	EventBus.point_changed.connect(_on_point_changed)


func _on_point_changed(new_point) -> void:
	if new_point >= price:
		$"Disable Overlay".hide()
		$Price.add_theme_color_override("default_color", Color.YELLOW)
	else:
		$"Disable Overlay".show()
		$Price.add_theme_color_override("default_color", Color.RED)

func _on_item_purchased(target_item: Item) -> void:
	if (item.name == target_item.name):
		price = GameState.calulate_price(item)
		$"Price".text = str(price)
	


func _on_button_pressed() -> void:
	EventBus.item_purchase.emit(item)
