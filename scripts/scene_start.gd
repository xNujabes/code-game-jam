extends Node2D


@onready var global_data = get_tree().root.get_node("Global")
@onready var best_score_label = $ColorRect/Score
var game

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

	# Supprimer tous les enfants actuels de la scène

	# Charger et instancier la scène des paramètres
	var settings_scene = load("res://scenes/scene_settings.tscn").instantiate()
	settings_scene.game = game
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(settings_scene)  # Ajouter la nouvelle scène
	get_tree().current_scene = settings_scene  # Définir la nouvelle scène comme scène actuelle

func _on_start_pressed() -> void:
	$ClickSound.play()
	if game:
		# Instancier la scène Main.tscn
		var main_scene = game.instantiate()
		get_tree().current_scene.queue_free()
		get_tree().root.add_child(main_scene)  # Ajouter la nouvelle scène
		get_tree().current_scene = main_scene  # Définir la nouvelle scène comme scène actuelle
	else:
		print("pas de jeu")


func _on_quitter_pressed() -> void:
	get_tree().quit()


func _on_classement_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Leadboard.tscn")
