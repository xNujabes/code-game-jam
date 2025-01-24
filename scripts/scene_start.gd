extends Node2D

signal start_game

@onready var global_data = get_tree().root.get_node("Global")
@onready var best_score_label = $ColorRect/Score

func _ready() -> void:
	update_best_score_display()

func update_best_score_display() -> void:
	var best_score_day = global_data.best_score.day
	var best_score_hour = global_data.best_score.hour
	var best_score_minute = global_data.best_score.minute

	var best_score_text = "Votre meilleur score : "
	best_score_text += str(best_score_day) + "j "
	best_score_text += str(best_score_hour) + "h "
	best_score_text += str(best_score_minute) + "min"

	if best_score_label:
		best_score_label.text = best_score_text

func show_message(text: String) -> void:
	$ColorRect/MessageTimer

func _on_settings_pressed_Settings() -> void:
	$ClickSound.play()
	get_tree().change_scene_to_file("res://scenes/scene_settings.tscn")

func _on_start_pressed() -> void:
	$ClickSound.play()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
