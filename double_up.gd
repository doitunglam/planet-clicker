extends Node2D

func _on_exit_pressed() -> void:
	queue_free()


func _on_confirm_pressed() -> void:
	GameState.set_mulitplier(2.0)
	queue_free()
