extends Node2D

@onready var camera = get_node("Player/Camera2D")
@onready var audio_player = get_node("Player/Music")
@onready var path2d = $Path2D
@onready var path_follow = $Path2D/PathFollow2D  # Ajout de l'initialisation du nœud PathFollow2D
@onready var spawn_timer = $SpawnMob
@onready var increase_enemies_timer = $IncreaseEnemies
@onready var boss_timer = $BossTime

var type_mob = 1

func _ready() -> void:
	# Assurer que le son de la musique est défini au démarrage
	if Global.is_muted:
		audio_player.volume_db = -80  # Met le volume à -80 dB pour le désactiver
	else:
		audio_player.volume_db = -10  # Volume activé (ajuste selon tes besoins)
	audio_player.play()

func _process(delta: float) -> void:
	if path2d:
		path2d.position = camera.global_position
		path2d.position -= Vector2(700, 500)

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

	if path_follow:
		path_follow.progress_ratio = randf()
		new_mob.global_position = path_follow.global_position
		new_mob.connect("death", Callable(self, "_on_mob_death"))  # Connexion au signal de mort avec Callable
		add_child(new_mob)

func _on_timer_timeout() -> void:
	spawn_mobs()

func _on_increase_enemies_timeout() -> void:
	if spawn_timer and spawn_timer.wait_time >= 0.3:
		spawn_timer.wait_time -= 0.2
	elif increase_enemies_timer:
		increase_enemies_timer.stop()

func _on_boss_time_timeout() -> void:
	# Stop les timers pour empêcher le spawn de mobs
	if spawn_timer:
		spawn_timer.stop()
	if increase_enemies_timer:
		increase_enemies_timer.stop()
	if boss_timer:
		boss_timer.stop()

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
		if child is CharacterBody2D and child.name != "Player":
			child.queue_free()  

func spawn_boss():
	var boss = preload("res://scenes/zombie_big.tscn").instantiate()

	boss.global_position = camera.global_position + Vector2(0, -200)
	
	boss.connect("boss_death", Callable(self, "_on_boss_death"))  # Connexion au signal de mort du boss avec Callable
	
	add_child(boss)

func _on_boss_death():
	if spawn_timer:
		spawn_timer.start()
	if increase_enemies_timer:
		increase_enemies_timer.start()
	if boss_timer:
		boss_timer.start()

func _on_mob_death(mob):
	var xp_instance = preload("res://scenes/xp.tscn").instantiate()
	xp_instance.global_position = mob.global_position
	add_child(xp_instance)
