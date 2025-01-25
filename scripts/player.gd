extends CharacterBody2D

@export var speed = 50.0
@export var hp = 80
@export var max_hp = 80

@export var xp = 0
@export var xp_to_level_up = 100
@export var max_xp = 100

@export var level = 1

var updatedInventory = false

# Weapons
var weapons = {
	"bullet": {
		"scene": preload("res://scenes/bullet.tscn"),
		"level": 1
	},
	"piano": {
		"scene": preload("res://scenes/piano.tscn"),
		"level": 1
	}
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

# Camera animation
@onready var animation_player = $AnimationPlayer

var enemyClose = []

func _ready() -> void:
	attack()
	update_hud()
	var score_timer = Timer.new()
	score_timer.wait_time = 1.0  
	score_timer.connect("timeout", Callable(self, "_on_score_timeout"))
	add_child(score_timer)
	score_timer.start()
	if weapons :
		update_hud_weapons()

func _physics_process(delta: float) -> void:
	move()
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
				"bullet":
					if bulletTimer:
						bulletTimer.wait_time = weapon_instance.attackSpeed
						if bulletTimer.is_stopped():
							bulletTimer.start()
					else:
						print("bulletTimer non trouvé")
				"piano":
					if pianoTimer:
						pianoTimer.wait_time = weapon_instance.attackSpeed
						if pianoTimer.is_stopped():
							pianoTimer.start()
					else:
						print("pianoTimer non trouvé")
			weapon_instance.queue_free()  # Libérer l'instance après avoir lu les propriétés

func _on_hurtbox_hurt(damage: Variant) -> void:
	$hitHurt.play()
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
		update_hud_weapons()
		updatedInventory = true
	
	#Level up
	if xp >= xp_to_level_up:
		$LevelUpSound.play()
		xp -= xp_to_level_up
		level += 1
		xp_to_level_up *= level
		max_xp = xp_to_level_up
		%Options.show_option()
		update_hud_weapons()
	
	update_hud()

func update_hud_weapons():
	if hud:
		hud.update_weapons(weapons)

func update_hud():
	if hud:
		hud.update_health(hp, max_hp)
		hud.update_xp(xp, max_xp, level)

func _on_bullet_timer_timeout() -> void:
	var bullet_instance = weapons["bullet"]["scene"].instantiate()
	bulletAmmo += bullet_instance.baseAmmo
	bullet_instance.queue_free()  # Libérer l'instance après avoir lu les propriétés
	bulletAttackTimer.start()

func _on_bullet_attack_timer_timeout() -> void:
	if bulletAmmo > 0:
		var bullet_instance = weapons["bullet"]["scene"].instantiate()
		bullet_instance.position = position
		if Global.fire_mode == "Avec la souris":
			var mouse_position = get_global_mouse_position()
			bullet_instance.direction = (mouse_position - position).normalized()
		else:
			bullet_instance.target = get_random_target()
		bullet_instance.level = weapons["bullet"]["level"]
		add_child(bullet_instance)
		bulletAmmo -= 1
		$Weapons/BulletSound.play()
		if bulletAmmo > 0:
			bulletAttackTimer.start()
		else:
			bulletAttackTimer.stop()

func get_random_target():
	if enemyClose.size() > 0:
		print(enemyClose.pick_random().global_position)
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
		global_data.scoregame = score
		# Met à jour le meilleur temps global
		if score > global_data.best_score:
			global_data.best_score = score
		# Change de scène vers game_over
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
