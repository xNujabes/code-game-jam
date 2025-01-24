extends Node2D

func _on_start_pressed_start():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/scene_settings.tscn")
