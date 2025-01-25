extends Node2D


@onready var canvas_layer = $CanvasLayer
@onready var canvas_modulate = $CanvasModulate
@onready var ui = $CanvasLayer/DayNightCycleUI
#@onready var sound_machine = $SoundMachine
@onready var camera = get_node("Player/Camera2D")
@onready var audio_player = get_node("Player/Music")
@onready var path2d = $Path2D
@onready var path_follow = $Path2D/PathFollow2D  # Ajout de l'initialisation du nœud PathFollow2D
@onready var spawn_timer = $SpawnMob
@onready var increase_enemies_timer = $IncreaseEnemies
@onready var boss_timer = $BossTime


# Variables globales
var type_mob = 1
var world_level = 1  # Niveau du monde qui augmente après chaque boss fight
var mob_paths = [  # Chemins vers les monstres
	"res://scenes/monstre1.tscn",
	"res://scenes/monstre2.tscn",
	"res://scenes/monstre3.tscn",
	"res://scenes/monstre4.tscn",
	"res://scenes/monstre5.tscn",
	"res://scenes/monstre6.tscn"
]

func _ready() -> void:
	# Assurer que le son de la musique est défini au démarrage
	if Global.is_muted:
		audio_player.volume_db = -80  # Met le volume à -80 dB pour le désactiver
	else:
		audio_player.volume_db = -80  # Volume activé (ajuste selon tes besoins)
	audio_player.play()
	canvas_layer.visible = true
	canvas_modulate.time_tick.connect(ui.set_daytime)
	$Corki.play()

func _process(delta: float) -> void:
	$Path2D.position = camera.global_position
	$Path2D.position -= Vector2(600, 300)

func spawn_mobs():
	# Choisir un type de mob en fonction du niveau du monde
	var available_mobs = get_mobs_for_world_level()
	var mob_path = available_mobs[randi() % available_mobs.size()]
	var new_mob = load(mob_path).instantiate()

	if path_follow:
		path_follow.progress_ratio = randf()
		new_mob.global_position = path_follow.global_position
		add_child(new_mob)

func get_mobs_for_world_level() -> Array:
	#Renvoie une liste de monstres disponibles en fonction du niveau du monde.
	match world_level:
		1:
			return [mob_paths[0], mob_paths[1]]
		2:
			return [mob_paths[0], mob_paths[1], mob_paths[2]] 
		3:
			return [mob_paths[1], mob_paths[2], mob_paths[3]]  
		4:
			return [mob_paths[2], mob_paths[3], mob_paths[4]]  
		5:
			return [mob_paths[3], mob_paths[4], mob_paths[5]]  
		_:
			return mob_paths  # Niveau 6+ : Tous les monstres disponibles
func _on_spawn_mob_timeout() -> void:
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
	
	# On augmente le niveau
	Global.niveauBoss += 1

	# Augmente le type de mobs (si applicable après le boss)
	type_mob += 1

func delete_all_enemies():
	for child in get_children():
		if child is CharacterBody2D and child.name != "Player":
			child.queue_free()  

func spawn_boss():
	var boss = preload("res://scenes/boss.tscn").instantiate()

	boss.global_position = camera.global_position + Vector2(0, -200)
	
	boss.connect("boss_death", Callable(self, "_on_boss_death"))  # Connexion au signal de mort du boss avec Callable
	
	add_child(boss)

func _on_boss_death():
	world_level += 1  # Augmenter le niveau du monde
	%SpawnMob.start()
	%IncreaseEnemies.start()
	%BossTime.start()


func _input(event):
	# Vérifie si l'action "elodie" est activée
	if Input.is_action_just_pressed("elodie"):
		open_youtube_video()

func open_youtube_video():
	var youtube_url = "https://www.youtube.com/watch?v=Qq1oH6AV8ww"
	OS.shell_open(youtube_url)
