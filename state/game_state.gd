extends Node

var point = 99999999999999
var redundant_point = 0
var point_per_click = 1
var point_per_second = 0

var item_count: Dictionary = {}

const PLANETS = [
	"Sun",
	"Mercury",
	"Venus",
	"Earth",
	"Mars",
	"Jupiter",
	"Saturn",
	"Neptune"
]
var current_planet_index = 3

var SHOP_ITEM_PLANET : Dictionary = {
	"Earth": [
		Item.create("Earth Clicker", "active", 2, "res://assets/planets/earth/earth_clicker.png"),
		Item.create("Campfire", "passive", 1, "res://assets/planets/earth/fire.png"),
		Item.create("Farm", "passive", 10, "res://assets/planets/earth/farm.png"),
		Item.create("Animal Farm", "passive", 120, "res://assets/planets/earth/animal-farm.png"),
		Item.create("Windmill", "passive", 1000, "res://assets/planets/earth/windmill.png"),
		Item.create("Factory", "passive", 5000, "res://assets/planets/earth/factory.png")
	]
}

const PLANET_IMG : Dictionary = {
	"Sun": {
		"normal": "res://assets/planets/sun/sun.png",
		"pressed": "res://assets/planets/sun/pressed_sun.png",
	},
	"Mercury": {
		"normal": "res://assets/planets/mercury/mercury.png",
		"pressed": "res://assets/planets/mercury/pressed_mercury.png",
	},
	"Venus": {
		"normal": "res://assets/planets/venus/venus.png",
		"pressed": "res://assets/planets/venus/pressed_venus.png",
	},
	"Earth": {
		"normal": "res://assets/planets/earth/earth.png",
		"pressed": "res://assets/planets/earth/pressed_earth.png",
	},
	"Mars": {
		"normal": "res://assets/planets/mars/mars.png",
		"pressed": "res://assets/planets/mars/pressed_mars.png",
	},
	"Jupiter": {
		"normal": "res://assets/planets/jupiter/jupiter.png",
		"pressed": "res://assets/planets/jupiter/pressed_jupiter.png",
	},
	"Saturn": {
		"normal": "res://assets/planets/saturn/saturn.png",
		"pressed": "res://assets/planets/saturn/pressed_saturn.png",
	},
	"Neptune": {
		"normal": "res://assets/planets/neptune/neptune.png",
		"pressed": "res://assets/planets/neptune/pressed_neptune.png",
	}
}

# Can also decrease point
# Decouple as much as possible
func _add_point(value) -> void:
	point += value
	EventBus.point_changed.emit(point)

func _add_point_per_second(value) -> void:
	point_per_second += value
	EventBus.point_per_second_changed.emit(point_per_second)

func calulate_price(item: Item) -> int:
	if (item_count.has(item)):
		return int(item.base_price * pow(1.5, item_count[item]))
	else:
		return item.base_price

func add_item(item: Item) -> void:
	if (item_count.has(item)):
		item_count[item] += 1
	else:
		item_count.set(item, 1)
	EventBus.item_purchased.emit(item)

func change_planet(direction: String) -> void:
	if (direction == "left"):
		if (current_planet_index == 0):
			return
		else:
			current_planet_index -= 1
			EventBus.planet_changed.emit(direction)
	else:
		if (current_planet_index == PLANETS.size()-1):
			return
		else:
			current_planet_index += 1
			EventBus.planet_changed.emit(direction)
