extends Node2D

func _on_exit_pressed() -> void:
	queue_free()

func _on_confirm_pressed() -> void:
	GameState._add_energy(18)
	queue_free()
