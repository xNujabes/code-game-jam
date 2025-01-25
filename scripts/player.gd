extends CharacterBody2D

@export var speed = 50.0
@export var hp = 80
@export var max_hp = 80

@export var xp = 0
@export var xp_to_level_up = 10
@export var max_xp = 10

@export var level = 1

var updatedInventory = false

# Weapons
var weapons = {
	"flute": {
		"scene": preload("res://scenes/bullet.tscn"),
		"level":1
	},
	"piano": {
		"scene": preload("res://scenes/piano.tscn"),
		"level": 0
	},
	"synth_wave": {
		"scene": preload("res://scenes/synth_wave.tscn"),
		"level": 0
	},
	"drum": {
		"scene": preload("res://scenes/drum.tscn"),
		"level": 0
	},
	"sax": {
		"scene": preload("res://scenes/Sax.tscn"),
		"level": 0
	}
}

var equipements = {
	"sac": {"level": 0},
	"casque": {"level": 0},
	"micro": {"level": 0},
	"claquette": {"level": 0},
	"lunettes": {"level": 0},
}

var score = 0  # Déclare la variable score

@onready var hud = get_tree().get_first_node_in_group("HUD")
@onready var global_data = get_tree().root.get_node("Global")  # Récupère le nœud global

@onready var bulletTimer = $Weapons/BulletTimer
@onready var bulletAttackTimer = $Weapons/BulletTimer/BulletAttackTimer

var bulletAmmo = 0

@onready var pianoTimer = $Weapons/PianoTimer
@onready var pianoAttackTimer = $Weapons/PianoTimer/PianoAttackTimer

var pianoAmmo = 0

@onready var waveTimer = $Weapons/WaveTimer
@onready var waveAttackTimer = $Weapons/WaveTimer/WaveAttackTimer

@onready var drumTimer = $Weapons/DrumTimer
@onready var drumAttackTimer = $Weapons/DrumTimer/DrumAttackTimer

var saxAmmo = 0

@onready var saxTimer = $Weapons/SaxTimer
@onready var saxAttackTimer = $Weapons/SaxTimer/SaxAttackTimer

# Camera animation
@onready var animation_player = $AnimationPlayer

var enemyClose = []

@onready var option_1 = $option_slot/option1
@onready var option_2 = $option_slot/option2
@onready var option_3 = $option_slot/option3
@onready var option_slot = $option_slot

var isHit = false
var isDead = false

func _ready() -> void:	
	attack()
	update_hud()
	var score_timer = Timer.new()
	score_timer.wait_time = 1.0  
	score_timer.connect("timeout", Callable(self, "_on_score_timeout"))
	add_child(score_timer)
	score_timer.start()
	%Options.majOptionPool("weapon", "flute", 1)

	if weapons && equipements :
		update_hud_weapons_equipment()


func _physics_process(delta: float) -> void:
	move()
	if !isHit and hp > 0:
		if velocity.length() > 0:
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.play("idle")
	game_over()
	

func move():
	var x_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_dir = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_dir, y_dir)
	velocity = mov.normalized() * speed
	move_and_slide()

func attack():
	for weapon_name in weapons:
		var weapon_data = weapons[weapon_name]
		if weapon_data["level"] > 0:  # Vérifie si l'arme est débloquée (niveau > 0)
			var weapon_instance = weapon_data["scene"].instantiate()
			match weapon_name:
				"flute":
					if bulletTimer:
						bulletTimer.wait_time = weapon_instance.attackSpeed
						if bulletTimer.is_stopped():
							bulletTimer.start()
					
				"piano":

					if pianoTimer:
						pianoTimer.wait_time = weapon_instance.attackSpeed
						if pianoTimer.is_stopped():
							pianoTimer.start()
					
				"synth_wave":
					if waveTimer:
						waveTimer.wait_time = 0
						if waveTimer.is_stopped():
							waveTimer.start()
				
				"drum":
					if drumTimer:
						drumTimer.wait_time = 15.0
						if drumTimer.is_stopped():
							drumTimer.start()
				"sax":
					if saxTimer:
						saxTimer.wait_time = weapon_instance.attackSpeed
						if saxTimer.is_stopped():
							saxTimer.start()
			weapon_instance.queue_free()  # Libérer l'instance après avoir lu les propriétés

func _on_hurtbox_hurt(damage: Variant) -> void:
	if hp > 0:
		$hitHurt.play()
		$AnimatedSprite2D.play("hit")
		isHit = true
		%DisableAnime.wait_time = 0.33
		%DisableAnime.start()	
	
	print("ah jai mal")
	hp -= damage
	if hp < 0:
		hp = 0
	animation_player.play("camera-shake")
	update_hud()

# Ajout de l'xp
func add_xp(amount):
	$XPSound.play()
	xp += amount
	if !updatedInventory:
		update_hud_weapons_equipment()
		updatedInventory = true
	
	#Level up
	if xp >= xp_to_level_up:
		$LevelUpSound.play()
		xp -= xp_to_level_up
		level += 1
		xp_to_level_up += level
		max_xp = xp_to_level_up
		%Options.show_option()
		
	
	update_hud()
	
func levelUpWeapon(name):
	#var weapon = weapons[name]
	#weapons[name].level += 1
	var weapon = ""
	if name == "flute":
		weapon = weapons["flute"]
		weapon.level+=1
	else :
		weapon = weapons[name]
		weapon.level += 1
	
	#if name == "bullet":
		#%Options.majOptionPool("weapon", "flute", weapons[name].level)
	#else :
	%Options.majOptionPool("weapon", name, weapon.level)
	update_hud_weapons_equipment()
	attack()
	
func levelUpEquipement(name):
	var equipement = equipements[name]
	equipement.level += 1 
	%Options.majOptionPool("equipement", name, equipement.level)
	update_hud_weapons_equipment()

func update_hud_weapons_equipment():
	if hud:
		hud.update_weapons(weapons)
		hud.update_equipment(equipements)

func update_hud():
	if hud:
		hud.update_health(hp, max_hp)
		hud.update_xp(xp, max_xp, level)

func _on_bullet_timer_timeout() -> void:
	var bullet_instance = weapons["flute"]["scene"].instantiate()
	bulletAmmo += bullet_instance.baseAmmo
	bullet_instance.queue_free()  # Libérer l'instance après avoir lu les propriétés
	bulletAttackTimer.start()

func _on_bullet_attack_timer_timeout() -> void:
	if bulletAmmo > 0:
		var bullet_instance = weapons["flute"]["scene"].instantiate()
		bullet_instance.position = position
		if Global.fire_mode == "Avec la souris":
			var mouse_position = get_global_mouse_position()
			bullet_instance.direction = (mouse_position - position).normalized()
		else:
			bullet_instance.target = get_closest_target()
		bullet_instance.level = weapons["flute"]["level"]
		bullet_instance.loadLevel()
		add_child(bullet_instance)
		bulletAmmo -= 1
		$Weapons/BulletSound.play()
		if bulletAmmo > 0:
			bulletAttackTimer.start()
		else:
			bulletAttackTimer.stop()

func get_random_target():
	if enemyClose.size() > 0:
		return enemyClose.pick_random().global_position
	else:
		return Vector2.UP
		
func get_closest_target():
	if enemyClose.size() > 0:
		var closest_enemy = null
		var closest_distance = INF  # Initialise avec une valeur infinie

		# Parcourir tous les ennemis dans la liste
		for enemy in enemyClose:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemy

		# Retourner la position de l'ennemi le plus proche
		return closest_enemy.global_position
	else:
		# Si aucun ennemi n'est trouvé, retourner une direction par défaut (par exemple, Vector2.UP)
		return Vector2.UP

func _on_range_detection_body_entered(body: Node2D) -> void:
	if not enemyClose.has(body):
		enemyClose.append(body)

func _on_range_detection_body_exited(body: Node2D) -> void:
	if enemyClose.has(body):
		enemyClose.erase(body)

func _on_piano_timer_timeout() -> void:
	var piano_instance = weapons["piano"]["scene"].instantiate()
	pianoAmmo += piano_instance.baseAmmo
	piano_instance.queue_free()  # Libérer l'instance après avoir lu les propriétés
	pianoAttackTimer.start()

func _on_piano_attack_timer_timeout() -> void:
	if pianoAmmo > 0:
		var pianoAttack = weapons["piano"]["scene"].instantiate()
		pianoAttack.position = position
		pianoAttack.target = get_closest_target()
		pianoAttack.level = weapons["piano"]["level"]
		pianoAttack.loadLevel()
		add_child(pianoAttack)
		pianoAmmo -= 1
		$Weapons/PianoSound.play()
		if pianoAmmo > 0:
			pianoAttackTimer.start()
		else:
			pianoAttackTimer.stop()

func _on_score_timeout() -> void:
	score += 1

func game_over():
	if hp <= 0:
		# Récupère les valeurs actuelles de jour, heure et minute
		var current_day = Global.day
		var current_hour = Global.hour
		var current_minute = Global.minute
		if %DeathAnime.is_stopped():
			%DeathAnime.wait_time = 1.5
			$AnimatedSprite2D.animation = "died"
			%DeathAnime.start()
			print("pas dans true")
			
		if isDead == true:
			print("dans le true")
			# Met à jour le meilleur score global si nécessaire
			Global.update_best_score(current_day, current_hour, current_minute)
			# Change de scène vers l'écran de game over
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func use_wave():
	var wave_instance = weapons["synth_wave"]["scene"].instantiate()
	wave_instance.position = position
	wave_instance.level = weapons["synth_wave"]["level"]
	wave_instance.loadLevel()
	add_child(wave_instance)


func _on_wave_timer_timeout() -> void:
	use_wave()
	$Weapons/WaveSound.play()

func invokeDrums():
	var projectile_instance = weapons["drum"]["scene"].instantiate()
	projectile_instance.position = position
	projectile_instance.level = weapons["drum"]["level"]
	projectile_instance.loadLevel()
	var number = projectile_instance.number
	add_child(projectile_instance)
	for i in range(number):
		projectile_instance = weapons["drum"]["scene"].instantiate()
		projectile_instance.position = position
		projectile_instance.level = weapons["drum"]["level"]
		add_child(projectile_instance)


func _on_drum_timer_timeout() -> void:
	invokeDrums()
	$Weapons/DrumSound.play()

func _on_sax_timer_timeout() -> void:
	var sax_instance = weapons["sax"]["scene"].instantiate()
	saxAmmo += sax_instance.baseAmmo
	sax_instance.queue_free()  # Libérer l'instance après avoir lu les propriétés
	saxAttackTimer.start()

func _on_sax_attack_timer_timeout() -> void:
	if saxAmmo > 0:
		var sax_instance = weapons["sax"]["scene"].instantiate()
		sax_instance.position = position
		sax_instance.target = get_random_target()
		sax_instance.level = weapons["sax"]["level"]
		sax_instance.loadLevel()
		add_child(sax_instance)
		saxAmmo -= 1
		$Weapons/SaxSound.play()
		if saxAmmo > 0:
			saxAttackTimer.start()
		else:
			saxAttackTimer.stop()


func _on_disable_anime_timeout() -> void:
	isHit = false


func _on_death_anime_timeout() -> void:
	isDead = true
