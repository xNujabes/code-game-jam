extends Node

@onready var global_data = get_tree().root.get_node("Global")
@onready var score_label = $Label2

func _ready() -> void:
	update_score_display()

func update_score_display() -> void:
	var score_seconds = global_data.scoregame  
	var minutes = score_seconds / 60
	var seconds = score_seconds % 60

	var score_text = "Votre Score: "
	if minutes > 0:
		score_text += str(minutes) + " min "
	score_text += str(seconds) + " s"

	if score_label:
		score_label.text = score_text

func _on_recommencé_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scene_start.tscn")
