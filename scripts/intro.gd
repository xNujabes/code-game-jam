extends Node2D

func _ready():
	
	$AnimationPlayer.play("Fade in")
	await get_tree().create_timer(6).timeout
	$AnimationPlayer.play("Fade out")
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/scene_start.tscn")
