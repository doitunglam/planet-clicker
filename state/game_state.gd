extends Node

var point = 0.0
var energy = 0
var multiplier = 1.0
var redundant_point = 0.0
var point_per_click_exp = 0.0
var point_per_second = 0.0

var item_count: Dictionary = {}

var highscore = 10.0

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

var PLANET_COLOR: Dictionary = {
	"Sun": "#FFD965",
	"Mercury": "#8854f6",
	"Venus": "#C89C6C",
	"Earth": "#2A82F2",
	"Mars": "#C64A42",
	"Jupiter": "#F28C28",
	"Saturn": "#FFA52F",
	"Neptune": "#7B9E99"
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

var SHOP_ITEM_PLANET : Dictionary = {
	"Sun": [
		Item.create("Sun Clicker", "active", 2, "res://assets/planets/sun/sun-clicker.png"), # 450 quintillion
		Item.create("Thermal Reactor", "passive", 300e18, "res://assets/planets/sun/thermal-reactor.png"), # 300 quintillion
		Item.create("Atomic Circuitry", "passive", 6.5e21, "res://assets/planets/sun/atomic-circulatory.png"), # 6.5 sextillion
		Item.create("Dyson Sphere", "passive", 150e21, "res://assets/planets/sun/dyson-sphere.png"), # 150 sextillion
		Item.create("Fusion Energy", "passive", 3.5e24, "res://assets/planets/sun/fusion-energy.png") # 3.5 septillion
	],
	"Mercury": [
		Item.create("Mercury Clicker", "active", 2, "res://assets/planets/mercury/mercury-clicker.png"), # 274.4 quadrillion
		Item.create("Iron Factory", "passive", 8e12, "res://assets/planets/mercury/iron-factory.png"), # 760.44 trillion
		Item.create("Nickel Mine", "passive", 500e12, "res://assets/planets/mercury/nickel-mine.png"), # 20 quadrillion
		Item.create("Coal Power Plant", "passive", 6e15, "res://assets/planets/mercury/coal-power-plant.png"), # 750 quadrillion
		Item.create("Grey Matter", "passive", 75e15, "res://assets/planets/mercury/grey-matter.png"), # 53.23 quintillion
		Item.create("Grey Matter Generator", "passive", 5e18, "res://assets/planets/mercury/grey-matter-generator.png") # 2.29 sextillion
	],
	"Venus": [
		Item.create("Venus Clicker", "active", 340.4e15, "res://assets/planets/venus/venus-clicker.png"), # 340.4 quadrillion
		Item.create("Thermal Energy", "passive", 1.6e9, "res://assets/planets/venus/thermal-energy.png"), # 1.6 billion
		Item.create("Atmosphere Generator", "passive", 90e9, "res://assets/planets/venus/atmosphere-generator.png"), # 90 billion
		Item.create("Oxygen Creator", "passive", 8e12, "res://assets/planets/venus/oxygen-creator.png"), # 8 trillion
		Item.create("Alien Tech", "passive", 50e12, "res://assets/planets/venus/alien-tech.png") # 50 trillion
  	],
	"Earth": [
		Item.create("Earth Clicker", "active", 2, "res://assets/planets/earth/earth-clicker.png"),
		Item.create("Campfire", "passive", 1, "res://assets/planets/earth/fire.png"),
		Item.create("Farm", "passive", 10, "res://assets/planets/earth/farm.png"),
		Item.create("Animal Farm", "passive", 120, "res://assets/planets/earth/animal-farm.png"),
		Item.create("Windmill", "passive", 1000, "res://assets/planets/earth/windmill.png"),
		Item.create("Factory", "passive", 5000, "res://assets/planets/earth/factory.png")
	],
	"Mars": [
		Item.create("Mars Clicker", "active", 2, "res://assets/planets/mars/mars-clicker.png"),
		Item.create("Solar Panels", "passive", 10e3, "res://assets/planets/mars/solar-panel.png"),
		Item.create("Oil Mine", "passive", 120e3, "res://assets/planets/mars/oil-mine.png"),
		Item.create("Coal Power Plant", "passive", 1.5e6, "res://assets/planets/mars/coal-power-plant.png"),
		Item.create("Nuclear Power Plant", "passive", 50e6, "res://assets/planets/mars/nuclear-power-plant.png"),
		Item.create("Marsian Technology", "passive", 750e6, "res://assets/planets/mars/marsian-technology.png")
	  ],
	"Jupiter": [
		Item.create("Jupiter Clicker", "active", 2, "res://assets/planets/jupiter/jupiter-clicker.png"), # 1.14 quintillion
		Item.create("Steam Engine", "passive", 5e9, "res://assets/planets/jupiter/steam-engine.png"), # 430.45 billion
		Item.create("Hydrogen Fusion Reactor", "passive", 100e9, "res://assets/planets/jupiter/hydrogen-fusion-reactor.png"), # 264.19 trillion
		Item.create("Helium Fusion Energy", "passive", 4.5e12, "res://assets/planets/jupiter/helium-fusion-energy.png"), # 26.94 quadrillion
		Item.create("Solar Radiation", "passive", 120e12, "res://assets/planets/jupiter/solar-radiation.png"), # 87.61 quadrillion
		Item.create("Thermal Radiation", "passive", 2.5e15, "res://assets/planets/jupiter/thermal-radiation.png") # 538.06 quadrillion
	],
	"Saturn": [
		Item.create("Saturn Clicker", "active", 2, "res://assets/planets/saturn/saturn-clicker.png"), # 2.5 quintillion
		Item.create("Gas Powered Energy", "passive", 200e15, "res://assets/planets/saturn/gas-powered-energy.png"), # 40.69 quintillion
		Item.create("Helium Mining", "passive", 10e18, "res://assets/planets/saturn/helium-mining.png"), # 1.77 sextillion
		Item.create("Rhea Moon Mining", "passive", 750e18, "res://assets/planets/saturn/rhea-moon-mining.png"), # 17.49 sextillion
		Item.create("Titan", "passive", 25e21, "res://assets/planets/saturn/titan.png"), # 6.99 septillion
		Item.create("Pressure Generator", "passive", 1.2e24, "res://assets/planets/saturn/pressure-generator.png") # 69.39 septillion
	],
	"Neptune": [
		Item.create("Neptune Clicker", "active", 2, "res://assets/planets/neptune/neptune-clicker.png"), # 350 nonillion
		Item.create("Methane Burning", "passive", 350e24, "res://assets/planets/neptune/methane-burning.png"), # 57.5 nonillion
		Item.create("Cyber Fusion", "passive", 8e27, "res://assets/planets/neptune/cyber-fusion.png"), # 809.11 nonillion
		Item.create("Alien Energy", "passive", 2e30, "res://assets/planets/neptune/alien-energy.png") # 20 decillion
	],
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

func _add_energy(value) -> void:
	energy += value
	EventBus.energy_changed.emit()

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
			EventBus.planet_change.emit(direction)
	else:
		if (current_planet_index == PLANETS.size()-1):
			return
		else:
			current_planet_index += 1
			EventBus.planet_change.emit(direction)

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

func set_mulitplier(new_multiplier: float):
	multiplier = new_multiplier
	EventBus.multiplier_changed.emit()
	await get_tree().create_timer(30.0).timeout
	multiplier = 1.0
	EventBus.multiplier_changed.emit()
	
