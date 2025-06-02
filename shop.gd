extends Node2D

signal item_selected(item_name: String, price: int, effectType: String, effectValue: int)

@onready var item_scene = preload("res://shop_item.tscn")
func _ready() -> void:
	EventBus.planet_change.connect(_on_planet_change)
	var current_planet = GameState.PLANETS[GameState.current_planet_index]
	var items = GameState.SHOP_ITEM_PLANET[current_planet]
	for i in items.size():
		var item = items[i]
		var shop_item = item_scene.instantiate()
		shop_item.item = item
		shop_item.position = Vector2(16, 80 + i * 104)
		$"Shop Items".add_child(shop_item)
		

func _on_planet_change(direction: String) -> void:
	var children = $"Shop Items".get_children()
	for child in children:
		child.free()
	var current_planet = GameState.PLANETS[GameState.current_planet_index]
	var items = GameState.SHOP_ITEM_PLANET[current_planet]
	for i in items.size():
		var item = items[i]
		var shop_item = item_scene.instantiate()
		shop_item.item = item
		shop_item.position = Vector2(16, 80 + i * 104)
		$"Shop Items".add_child(shop_item)
