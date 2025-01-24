extends Node2D

@onready var camera = get_node("Player/Camera2D")

var type_mob = 1

func _process(delta: float) -> void:
	$Path2D.position = camera.global_position
	$Path2D.position -= Vector2(700, 500)

func spawn_mobs():
	var new_mob
	if type_mob == 1:
		new_mob = preload("res://scenes/zombie_basic.tscn").instantiate()
	elif type_mob == 2:
		new_mob = preload("res://scenes/zombie_blind.tscn").instantiate()
	else:
		if randi() % 2 == 0:
			new_mob = preload("res://scenes/zombie_basic.tscn").instantiate()
		else:
			new_mob = preload("res://scenes/zombie_blind.tscn").instantiate()

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
	# Stop les timers pour empêcher le spawn de mobs
	%SpawnMob.stop()
	%IncreaseEnemies.stop()
	%BossTime.stop()

	# Supprime tous les ennemis existants
	delete_all_enemies()

	# Affiche un message de debug
	print("Boss Time")
	
	# Charge l'arène et affiche le boss
	spawn_boss()

	# Augmente le type de mobs (si applicable après le boss)
	type_mob += 1

func delete_all_enemies():
	for child in get_children():
		# Vérifie si l'enfant est un CharacterBody2D (type des ennemis)
		if child is CharacterBody2D and not child.name == "Player":
			child.queue_free()  # Supprime cet ennemi

func spawn_boss():
	# Précharge et instancie la scène du boss
	var boss = preload("res://scenes/zombie_big.tscn").instantiate()

	# Positionne le boss au centre de la caméra ou une position spécifique
	boss.global_position = camera.global_position + Vector2(0, -200)
	
	# On associe le signal en mode le dentifrice lol
	boss.connect("boss_death", Callable(self, "_on_boss_death"))
	
	# Ajoute le boss à la scène
	add_child(boss)

func _on_boss_death():
	%SpawnMob.start()
	%IncreaseEnemies.start()
	%BossTime.start()
