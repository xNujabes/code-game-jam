extends Node2D

@onready var camera = get_node("Player/Camera2D")

func _process(delta: float) -> void:
	$Path2D.position = camera.global_position
	$Path2D.position -= Vector2(500, 350)

func spawn_mobs():
	var new_mob = preload("res://scenes/enemy.tscn").instantiate()
	
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	
	add_child(new_mob)


func _on_timer_timeout() -> void:
	spawn_mobs()
