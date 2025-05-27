extends Node

var point = 0.0
var redundant_point = 0.0
var point_per_click_exp = 0.0
var point_per_second = 0.0

var item_count: Dictionary = {}

var highscore = 1000.0

var purchased_planet: Dictionary = {
	"Earth": 1
}
var PLANET_PRICE: Dictionary = {
	"Sun": 69e18,
	"Mercury": 10e12,
	"Venus": 50e9,
	"Earth": 0,
	"Mars": 2e6,
	"Jupiter": 150e9,
	"Saturn": 750e15,
	"Neptune": 690e21
}
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

var SHOP_ITEM = [
		Item.create("2X Click Power", "active", 2, "res://assets/icons/bolt-solid.png"),
		Item.create("Nano-Bot Harvester", "passive", 1, "res://assets/icons/robot-solid.png"),
		Item.create("Solar Energy Collector", "passive", 10, "res://assets/icons/solar-panel-solid.png"),
		Item.create("Bio-Dome Maker", "passive", 120, "res://assets/icons/leaf-solid.png"),
		Item.create("Stellar Wind Turbine", "passive", 1000, "res://assets/icons/wind-solid.png"),
		Item.create("Galactic Energy Forge", "passive", 5000, "res://assets/icons/industry-solid.png")
]

var SHOP_ITEM_PLANET : Dictionary = {
	"Sun": [
		Item.create("2X Click Power", "active", 2, "res://assets/icons/bolt-solid.png"),
		Item.create("Nano-Bot Harvester", "passive", 300e18, "res://assets/icons/robot-solid.png"),
		Item.create("Solar Energy Collector", "passive", 6.5e21, "res://assets/icons/solar-panel-solid.png"),
		Item.create("Bio-Dome Maker", "passive", 150e21, "res://assets/icons/leaf-solid.png"),
		Item.create("Stellar Wind Turbine", "passive", 3.5e24, "res://assets/icons/wind-solid.png"),
		Item.create("Galactic Energy Forge", "passive", 25e24, "res://assets/icons/industry-solid.png")

	],
	"Mercury": [
		Item.create("2X Click Power", "active", 2, "res://assets/icons/bolt-solid.png"),
		Item.create("Nano-Bot Harvester", "passive", 8e12, "res://assets/icons/robot-solid.png"),
		Item.create("Solar Energy Collector", "passive", 500e12, "res://assets/icons/solar-panel-solid.png"),
		Item.create("Bio-Dome Maker", "passive", 6e15, "res://assets/icons/leaf-solid.png"),
		Item.create("Stellar Wind Turbine", "passive", 75e15, "res://assets/icons/wind-solid.png"),
		Item.create("Galactic Energy Forge", "passive", 5e18, "res://assets/icons/industry-solid.png")
	],
	"Venus": [
		Item.create("2X Click Power", "active", 340.4e15, "res://assets/icons/bolt-solid.png"),
		Item.create("Nano-Bot Harvester", "passive", 1.6e9, "res://assets/icons/robot-solid.png"),
		Item.create("Solar Energy Collector", "passive", 90e9, "res://assets/icons/solar-panel-solid.png"),
		Item.create("Bio-Dome Maker", "passive", 8e12, "res://assets/icons/leaf-solid.png"),
		Item.create("Stellar Wind Turbine", "passive", 50e12, "res://assets/icons/wind-solid.png"),
		Item.create("Galactic Energy Forge", "passive", 2.5e15, "res://assets/icons/industry-solid.png")

	],
	"Earth": [
		Item.create("2X Click Power", "active", 2, "res://assets/icons/bolt-solid.png"),
		Item.create("Nano-Bot Harvester", "passive", 1, "res://assets/icons/robot-solid.png"),
		Item.create("Solar Energy Collector", "passive", 10, "res://assets/icons/solar-panel-solid.png"),
		Item.create("Bio-Dome Maker", "passive", 120, "res://assets/icons/leaf-solid.png"),
		Item.create("Stellar Wind Turbine", "passive", 1000, "res://assets/icons/wind-solid.png"),
		Item.create("Galactic Energy Forge", "passive", 5000, "res://assets/icons/industry-solid.png")
	],
	"Mars": [
		Item.create("2X Click Power", "active", 2, "res://assets/icons/bolt-solid.png"),
		Item.create("Nano-Bot Harvester", "passive", 10e3, "res://assets/icons/robot-solid.png"),
		Item.create("Solar Energy Collector", "passive", 120e3, "res://assets/icons/solar-panel-solid.png"),
		Item.create("Bio-Dome Maker", "passive", 1.5e6, "res://assets/icons/leaf-solid.png"),
		Item.create("Stellar Wind Turbine", "passive", 50e6, "res://assets/icons/wind-solid.png"),
		Item.create("Galactic Energy Forge", "passive", 750e6, "res://assets/icons/industry-solid.png")
	],
	"Jupiter": [
		Item.create("2X Click Power", "active", 2, "res://assets/icons/bolt-solid.png"),
		Item.create("Nano-Bot Harvester", "passive", 5e9, "res://assets/icons/robot-solid.png"),
		Item.create("Solar Energy Collector", "passive", 100e9, "res://assets/icons/solar-panel-solid.png"),
		Item.create("Bio-Dome Maker", "passive", 4.5e12, "res://assets/icons/leaf-solid.png"),
		Item.create("Stellar Wind Turbine", "passive", 120e12, "res://assets/icons/wind-solid.png"),
		Item.create("Galactic Energy Forge", "passive", 2.5e15, "res://assets/icons/industry-solid.png")
	],
	"Saturn": [
		Item.create("2X Click Power", "active", 2, "res://assets/icons/bolt-solid.png"),
		Item.create("Nano-Bot Harvester", "passive", 200e15, "res://assets/icons/robot-solid.png"),
		Item.create("Solar Energy Collector", "passive", 10e18, "res://assets/icons/solar-panel-solid.png"),
		Item.create("Bio-Dome Maker", "passive", 750e18, "res://assets/icons/leaf-solid.png"),
		Item.create("Stellar Wind Turbine", "passive", 25e21, "res://assets/icons/wind-solid.png"),
		Item.create("Galactic Energy Forge", "passive", 5e24, "res://assets/icons/industry-solid.png")

	],
	"Neptune": [
		Item.create("2X Click Power", "active", 2, "res://assets/icons/bolt-solid.png"),
		Item.create("Nano-Bot Harvester", "passive", 350e24, "res://assets/icons/robot-solid.png"),
		Item.create("Solar Energy Collector", "passive", 8e27, "res://assets/icons/solar-panel-solid.png"),
		Item.create("Bio-Dome Maker", "passive", 2e30, "res://assets/icons/leaf-solid.png"),
		Item.create("Stellar Wind Turbine", "passive", 150e30, "res://assets/icons/wind-solid.png"),
		Item.create("Galactic Energy Forge", "passive", 2.5e33, "res://assets/icons/industry-solid.png")
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

func calulate_price(item: Item) -> float:
	if item.effect_type == "passive":
		if (item_count.has(item)):
			return item.base_price * pow(1.5, item_count[item])
		else:
			return item.base_price
	else:
		return 100 * pow(10, point_per_click_exp)

func add_item(item: Item) -> void:
	if (item_count.has(item)):
		item_count[item] += 1
	else:
		item_count.set(item, 1)
	EventBus.item_purchased.emit(item)

func add_planet(planet_name: String) -> void:
	purchased_planet.set(planet_name, 1)
	EventBus.planet_purchased.emit(planet_name)
	
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

# Converts a number to a short format with suffix (e.g., 1_000_000 => "1M")
func format_number(n: float) -> String:
	var suffixes = [
		"", 
		"thousand", 
		"million", 
		"billion", 
		"trillion", 
		"quadrillion", 
		"quintillion", 
		"sextillion", 
		"septillion", 
		"octillion", 
		"nonillion", 
		"decillion", 
		"undecillion", 
		"duodecillion", 
		"tredecillion", 
		"quattuordecillion", 
		"quindecillion", 
		"sexdecillion", 
		"septendecillion", 
		"octodecillion", 
		"novemdecillion"
	]
	if n < 1000_000:
		return str(int(n))  # round to 2 decimals

	var exponent = int(floor(log(n) / (log(10)* 3.0)))
	exponent = clamp(exponent, 0, suffixes.size() - 1)
	var value = n / pow(1000, exponent)
	if abs(value - round(value * 100.0) / 100.0) * 1000.0 < 1:
		return str(int(value)) + " " + suffixes[exponent]
	else:
		return str(round(value * 100.0) / 100.0) + " " + suffixes[exponent]
