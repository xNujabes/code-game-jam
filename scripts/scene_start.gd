extends Node2D

signal start_game

func show_message(text):
	$ColorRect/MessageTimer

func _on_settings_pressed_Settings():
	$ClickSound.play()
	get_tree().change_scene_to_file("res://scenes/scene_settings.tscn")


func _on_start_pressed():
	$ClickSound.play()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
