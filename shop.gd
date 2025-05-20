extends Node2D

signal item_selected(item_name: String, price: int, effectType: String, effectValue: int)

var items = [
	{ "name": "Item 0", "price": 1, "effect_type": "passive", "effect_value": 1 },
	{ "name": "Item 1", "price": 5, "effect_type": "active", "effect_value": 2 },
	{ "name": "Item 2", "price": 10, "effect_type": "passive", "effect_value": 5 },
	{ "name": "Item 3", "price": 20, "effect_type": "passive", "effect_value": 10 },
	{ "name": "Item 4", "price": 100, "effect_type": "passive", "effect_value": 20 },
]

func _ready() -> void:
	var item_scene = preload("res://shop_item.tscn")
	
	for i in items.size():
		var data = items[i]
		var shop_item = item_scene.instantiate()
		var item = Item.new()
		item.name = data.name
		item.base_price = data.price
		item.effect_type = data.effect_type
		item.effect_value = data.effect_value
		
		shop_item.item = item
		shop_item.position = Vector2(16, 80 + i * 96)
		add_child(shop_item)
