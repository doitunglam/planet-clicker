extends Node2D

signal item_selected(item_name: String, price: int, effectType: String, effectValue: int)

func _ready() -> void:
	var item_scene = preload("res://shop_item.tscn")
	var current_planet = GameState.PLANETS[GameState.current_planet_index]
	var items = GameState.SHOP_ITEM_PLANET[current_planet]
	for i in items.size():
		var item = items[i]
		var shop_item = item_scene.instantiate()
		shop_item.item = item
		shop_item.position = Vector2(16, 80 + i * 104)
		add_child(shop_item)
