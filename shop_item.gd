extends TextureButton

@export var item_name: String
@export var price: int
@export var effect_type: String
@export var effect_value: int

signal item_selected(item_name: String, price: int, effect_type: String, effect_value: int)

func _ready():
	$"Name".text = item_name
	$"Effect".text = "Effect: " + effect_type + " " +  str(effect_value)
	$"Price".text = str(effect_value)

func _on_pressed() -> void:
	emit_signal("item_selected", item_name, price, effect_type, effect_value)
