extends Node

# GameState signals
signal point_changed(new_point)
signal point_per_second_changed(new_point_per_second)

# Item signals
signal item_purchase(item)
signal item_purchased(item)


# Planet signals
signal planet_changed(direction: String)
signal change_planet(direction: String)
