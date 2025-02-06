extends Node2D  # Utilise Node2D au lieu de Sprite2D

@onready var global_data = get_tree().root.get_node("Global")

var game: Node

func _ready() -> void:
	if game:
		print("Game chargé correctement :", game)
	else:
		print("⚠️ Aucune instance de game reçue")

func _on_retour_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scene_start.tscn")
