extends Node2D

var point = 0

var redundant_point = 0

var point_per_click = 1
var point_per_second = 0

func _buy_effect(price: int, effectType: String, effectValue: int) -> void:
	if (point < price):
		return
	if (effectType == "passive"):
		point -= price
		_add_point_per_second(effectValue)
		
	if (effectType == "active"):
		point -= price
		point_per_click += effectValue

func _add_point_per_second(value: int) -> void:
	point_per_second = point_per_second + value
	$"UI/Scoreboard/Point Per Second".text = str(point_per_second)

func _ready() -> void:
	$"UI/Scoreboard/Point".text = str(point)
	_add_point_per_second(0)

	$UI/Menu.connect("item_selected", _buy_effect)

@onready var flying_text_scene = preload("res://flying_text.tscn")
func _on_planet_pressed() -> void:
	var text = flying_text_scene.instantiate()
	var mouse_pos = get_viewport().get_mouse_position()
	text.setup("+%s" % str(point_per_click), mouse_pos)
	$UI.add_child(text)
	
	point = point + point_per_click
	$"UI/Scoreboard/Point".text = str(point)


func _on_timer_timeout() -> void:
	var increase_point = point_per_second * 0.1 + redundant_point
	redundant_point = increase_point - int(increase_point)
	
	point += int(increase_point)
	$"UI/Scoreboard/Point".text = str(point)
