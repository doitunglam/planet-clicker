extends TextureButton

var item: Item

signal item_selected(item_name: String, price: int, effect_type: String, effect_value: int)

func _ready():
	$"Name".text = item.name
	$"Effect".text = "Effect: " + item.effect_type + " " +  str(item.effect_value)
	$"Price".text = str(GameState.calulate_price(item))
	EventBus.item_purchased.connect(_on_item_purchased)

func _on_pressed() -> void:
	EventBus.item_purchase.emit(item)
	
func _on_item_purchased(target_item: Item) -> void:
	if (item.name != target_item.name):
		return
	else:
		$"Price".text = str(GameState.calulate_price(item))
	
