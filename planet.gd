extends Node2D

@export var texture_normal_link: String = ''
@export var texture_pressed_link: String =  ''

func _ready() -> void:
	if texture_normal_link != '':
		$PlanetTexture.texture_normal = load(texture_normal_link)
	if texture_pressed_link != '':
		$PlanetTexture.texture_pressed = load(texture_pressed_link)
	#EventBus.planet_purchased.connect()

func _on_planet_rotation_timer_timeout() -> void:
	$"PlanetTexture".rotation_degrees += 0.5

@onready var flying_text_scene = preload("res://flying_text.tscn")
func _on_planet_texture_pressed() -> void:
	var text = flying_text_scene.instantiate()
	var mouse_pos = get_viewport().get_mouse_position()
	text.setup(mouse_pos)
	add_child(text)
	
	GameState._add_point(pow(2, GameState.point_per_click_exp))
