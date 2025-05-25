class_name Item

@export var name: String = "undefined"
@export var base_price: float = -1.0
@export var effect_type: String = "undefined"
@export var effect_value: float = -1.0
@export var icon_path: String = "undefined"

static func create(name: String, effect_type: String, effect_value: float, icon_path: String) -> Item:
	var item = Item.new()
	item.name = name
	item.base_price = effect_value * 20
	item.effect_type = effect_type
	item.effect_value = effect_value
	item.icon_path = icon_path
	return item
