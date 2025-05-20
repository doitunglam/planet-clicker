extends Node

var point = 0
var redundant_point = 0
var point_per_click = 1
var point_per_second = 0

var item_count: Dictionary = {}

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
