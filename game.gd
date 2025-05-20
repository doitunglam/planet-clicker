extends Node2D

var redundant_point = 0

func _add_point_per_second(value: int) -> void:
	GameState._add_point_per_second(value)

func _ready() -> void:	
	EventBus.item_purchase.connect(_on_item_purchase)

func _on_item_purchase(item: Item) -> void:
	var item_price = GameState.calulate_price(item)
	
	if (GameState.point < item_price):
		return

	GameState._add_point(-item_price)
	GameState.add_item(item)

	if (item.effect_type == "passive"):
		_add_point_per_second(item.effect_value)
		
	if (item.effect_type == "active"):
		GameState.point_per_click += item.effect_value

@onready var flying_text_scene = preload("res://flying_text.tscn")
func _on_planet_pressed() -> void:
	var text = flying_text_scene.instantiate()
	var mouse_pos = get_viewport().get_mouse_position()
	text.setup("+%s" % str(GameState.point_per_click), mouse_pos)
	$UI.add_child(text)
	
	GameState._add_point(GameState.point_per_click)
	
func _on_timer_timeout() -> void:
	var increase_point = GameState.point_per_second * 0.1 + redundant_point
	redundant_point = increase_point - int(increase_point)
	
	GameState._add_point(int(increase_point))

func _on_planet_rotation_timer_timeout() -> void:
	$UI/Planet.rotation_degrees += 1
