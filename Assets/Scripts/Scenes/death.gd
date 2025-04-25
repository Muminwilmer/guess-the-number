extends Control



func _on_button_pressed() -> void:
	Global._resetVar()
	get_tree().change_scene_to_file("res://Assets/Scenes/LevelScenes/guess_screen.tscn")
