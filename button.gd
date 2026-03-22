extends Button

func _on_close_button_pressed() -> void:
	get_tree().current_scene.queue_free()
	get_tree().change_scene_to_file("res://main.tscn")
