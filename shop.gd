extends Node2D

signal item_selected(item_name: String, price: int, effectType: String, effectValue: int)

var items_data = [
	{ "name": "Item 0", "price": 1, "effect_type": "passive", "effect_value": 1 },
	{ "name": "Item 1", "price": 5, "effect_type": "active", "effect_value": 2 },
	{ "name": "Item 2", "price": 10, "effect_type": "passive", "effect_value": 5 },
	{ "name": "Item 3", "price": 20, "effect_type": "passive", "effect_value": 10 },
	{ "name": "Item 4", "price": 100, "effect_type": "passive", "effect_value": 20 },
]

func _ready() -> void:
	var item_scene = preload("res://shop_item.tscn")
	
	for i in items_data.size():
		var data = items_data[i]
		var item = item_scene.instantiate()

		item.item_name = data["name"]
		item.price = data["price"]
		item.effect_type = data["effect_type"]
		item.effect_value = data["effect_value"]
		item.position = Vector2(16, 80 + i * 96)
		item.connect("item_selected", _on_item_selected)

		add_child(item)

func _on_item_selected(item_name: String, price: int, effectType: String, effectValue: int):
	emit_signal("item_selected", price, effectType, effectValue)
