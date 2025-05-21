extends Node2D

signal item_selected(item_name: String, price: int, effectType: String, effectValue: int)

var items = [
	{ "name": "Earth Clicker", "effect_type": "passive", "effect_value": 1 },
	{ "name": "Campfire", "effect_type": "active", "effect_value": 2 },
	{ "name": "Farm", "effect_type": "passive", "effect_value": 120 },
	{ "name": "Animal Farm", "effect_type": "passive", "effect_value": 1000 },
	{ "name": "Windmill", "effect_type": "passive", "effect_value": 5000 },
	{ "name": "Factory", "effect_type": "passive", "effect_value": 5000 },
]

func _ready() -> void:
	var item_scene = preload("res://shop_item.tscn")
	
	for i in items.size():
		var data = items[i]
		var shop_item = item_scene.instantiate()
		var item = Item.new()
		item.name = data.name
		item.base_price = data.effect_value * 20
		item.effect_type = data.effect_type
		item.effect_value = data.effect_value
		
		shop_item.item = item
		shop_item.position = Vector2(16, 88 + i * 104)
		add_child(shop_item)
