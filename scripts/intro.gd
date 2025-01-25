extends Node2D

func _ready():
	# Préparer l'action "click" définie dans le projet
	set_process(true)
	$AnimationPlayer.play("Fade in")
	await get_tree().create_timer(4).timeout
	$AnimationPlayer.play("Fade out")
	await get_tree().create_timer(20).timeout
	get_tree().change_scene_to_file("res://scenes/scene_start.tscn")

func _process(delta):
	# Vérifier si l'action "click" a été pressée

	if Input.is_action_just_pressed("click"):
		_handle_click()

func _handle_click():
	get_tree().change_scene_to_file("res://scenes/scene_start.tscn")
	# Gérer les étapes de l'animation et du changement de scène
