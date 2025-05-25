extends Node2D

func _ready():
	$Point.text = '0'
	$"Point Per Second".text = '0'
	
	EventBus.point_per_second_changed.connect(_on_point_per_second_changed)
	EventBus.point_changed.connect(_on_point_changed)

func _on_point_per_second_changed(new_point_per_second) -> void:
		$"Point Per Second".text = GameState.format_number(new_point_per_second)
		
func _on_point_changed(new_point: float) -> void:
		$"Point".text = GameState.format_number(new_point)
