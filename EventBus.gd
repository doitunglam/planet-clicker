extends Node

# GameState signals
signal point_changed(new_point: float)
signal point_per_second_changed(new_point_per_second: float)

# Item signals
signal item_purchase(item: Item, price: Array)
signal item_purchased(item: Item)

# Planet signals
signal planet_purchase(planet: String)
signal planet_purchased(planet: String)
signal planet_change(direction: String)
signal planet_changed(direction: String)
signal change_planet(direction: String)
signal planet_clicked()
signal multiplier_changed()
signal energy_changed()
