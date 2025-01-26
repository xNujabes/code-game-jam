extends Node

@onready var global_data = get_tree().root.get_node("Global")
@onready var score_label = $Label2

func _ready() -> void:
	update_score_display()

func update_score_display() -> void:
	var day_score = global_data.day
	var hour_score = global_data.hour
	var min_score = global_data.minute

	var score_text = "Vous avez survécu: "
	score_text += str(day_score) + "d "
	score_text += str(hour_score) + "h "
	score_text += str(min_score) + "min"

	if score_label:
		score_label.text = score_text

func _on_recommencé_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/intro.tscn")
