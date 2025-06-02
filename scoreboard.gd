extends Node2D

func _ready():
	$Point.text = GameState.format_number(GameState.point)
	$"Energy Count".text = str(GameState.energy)
	$"Point Per Second".text = GameState.format_number(GameState.point_per_second)
	EventBus.multiplier_changed.connect(_on_muliplier_changed)
	EventBus.point_per_second_changed.connect(_on_point_per_second_changed)
	EventBus.point_changed.connect(_on_point_changed)
	EventBus.energy_changed.connect(_on_energy_changed)

func _on_point_per_second_changed(new_point_per_second) -> void:
		$"Point Per Second".text = GameState.format_number(new_point_per_second*GameState.multiplier)
		
func _on_point_changed(new_point: float) -> void:
	$"Point".text = GameState.format_number(new_point)

func _on_energy_changed() -> void:
	$"Energy Count".text = str(GameState.energy)

func _on_muliplier_changed():
	$"Point Per Second".text = GameState.format_number(GameState.point_per_second*GameState.multiplier)
