extends Node2D

signal start_game

@onready var global_data = get_tree().root.get_node("Global")
@onready var best_score_label = $ColorRect/Score
@onready var music = $MusiqueIntro

func _ready() -> void:
	update_best_score_display()
	if Global.is_muted:
		music.volume_db = -80  
	else:
		music.volume_db = -10  
		music.play()

func update_best_score_display() -> void:
	var best_score_seconds = global_data.best_score
	var minutes = best_score_seconds / 60
	var seconds = best_score_seconds % 60

	var best_score_text = "Votre meilleur temps : "
	if minutes > 0:
		best_score_text += str(minutes) + " min "
	best_score_text += str(seconds) + " s"

	if best_score_label:
		best_score_label.text = best_score_text
	music.play()
	
	
func show_message(text: String) -> void:
	$ColorRect/MessageTimer

func _on_settings_pressed_Settings() -> void:
	$ClickSound.play()
	get_tree().change_scene_to_file("res://scenes/scene_settings.tscn")

func _on_start_pressed() -> void:
	$ClickSound.play()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
