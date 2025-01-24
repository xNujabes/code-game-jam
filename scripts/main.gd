extends Node2D

@onready var camera = get_node("Player/Camera2D")

var type_mob = 1

func _process(delta: float) -> void:
	$Path2D.position = camera.global_position
	$Path2D.position -= Vector2(500, 350)

func spawn_mobs():
	var new_mob
	if type_mob == 1:
		new_mob = preload("res://scenes/zombie_basic.tscn").instantiate()
	elif type_mob == 2:
		new_mob = preload("res://scenes/zombie_basic.tscn").instantiate()
	else:
		new_mob = preload("res://scenes/zombie_basic.tscn").instantiate()

	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	
	add_child(new_mob)


func _on_timer_timeout() -> void:
	spawn_mobs()


func _on_increase_enemies_timeout() -> void:
	if %SpawnMob.wait_time >= 0.3:
		%SpawnMob.wait_time -= 0.2
	else:
		%IncreaseEnemies.stop()


func _on_boss_time_timeout() -> void:
	%SpawnMob.stop()
	%IncreaseEnemies.stop()
	print("Boss Time")
	type_mob += 1
