extends Node2D

@onready var viser_button = $ColorRect/Viser
@onready var mute_button = $ColorRect/MuteButton
var game

func _on_return_pressed_return_settings():
	var menu = load("res://scenes/scene_start.tscn").instantiate()
	menu.game = game
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(menu)  # Ajouter la nouvelle scène
	get_tree().current_scene = menu  # Définir la nouvelle scène comme scène actuelle

func _ready():
	if mute_button:
		mute_button.connect("pressed", Callable(self, "_on_mute_button_pressed"))
	_load_aim_mode()
	_update_mute_button_text()

func _load_aim_mode():
	viser_button.text = Global.fire_mode

func _save_aim_mode():
	Global.fire_mode = viser_button.text

func _on_viser_pressed() -> void:
	if viser_button.text == "Avec la souris":
		viser_button.text = "Auto"
	elif viser_button.text == "Auto":
		viser_button.text = "Avec la souris"
	_save_aim_mode()

func _on_mute_button_pressed() -> void:
	Global.is_muted = !Global.is_muted
	var music_node = get_tree().get_root().get_node("Main/Player/Music")
	if Global.is_muted:
		mute_button.text = "Désactivé"
		if music_node:
			music_node.volume_db = -80  
	else:
		mute_button.text = "Activé"
		if music_node:
			music_node.volume_db = -10 
	_update_mute_button_text()

func _update_mute_button_text():
	if mute_button:
		mute_button.text = ("Activé" if not Global.is_muted else "Désactivé")
