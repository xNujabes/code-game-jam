extends Node

@onready var global_data = get_tree().root.get_node("Global")
@onready var score_label = $Label2

func _ready() -> void:
	update_score_display()

func update_score_display() -> void:
	var score_text = "Vous avez survécu: "
	
	score_text += str(global_data.day) + "j "
	score_text += str(global_data.hour) + "h "
	score_text += str(global_data.minute) + "min"

	if score_label:
		score_label.text = score_text

func _on_recommencé_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scene_start.tscn")
