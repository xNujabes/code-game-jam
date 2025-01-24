extends Node2D

@onready var audio_player = $AudioStreamPlayer2D
@onready var slider = $ColorRect/HSlider
@onready var value_label = $ColorRect/Label3 

func _on_return_pressed_return_settings():
	get_tree().change_scene_to_file("res://scenes/scene_start.tscn")

func _ready():
	slider.value = 100  
	slider.value_changed.connect(_on_volume_changed)  
	_update_value_label(slider.value)

func _on_volume_changed(value):
	audio_player.volume_db = lerp(-80, 0, value / 100.0)  
	_update_value_label(value)

func _update_value_label(value):
	value_label.text = str(value)  
