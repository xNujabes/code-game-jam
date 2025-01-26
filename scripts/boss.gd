extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $VieBigZombie
var niveauBoss = Global.niveauBoss

@export var base_speed = 20.0  # Vitesse de base pour le niveau 1
@export var base_hp = 300  # Points de vie de base pour le niveau 1
@export var base_damage = 50  # Dégâts de base pour le niveau 1
@export var growth_factor = 1.5  # Facteur de croissance exponentielle

var speed : float
var hp : int
var max_hp : int
var damage : int

var isAnimated = false
var isTouched = false
var isDead = false
var isCharging = false

@onready var player = get_tree().get_first_node_in_group("player")

signal boss_death


func _ready() -> void:
	special_attack()
	
	# Calcul des statistiques en fonction du niveau du boss
	speed = base_speed * pow(growth_factor, niveauBoss - 1)
	hp = base_hp * pow(growth_factor, niveauBoss - 1)
	max_hp = hp
	damage = base_damage * pow(growth_factor, niveauBoss - 1)
	

func update_health_boss(current_hp, max_hp):
	if health_bar:
		health_bar.value = current_hp
		health_bar.max_value = max_hp
	if health_bar.visible == false:
		health_bar.visible = true

func _process(delta: float) -> void:
	if not isTouched and not isCharging:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		
		if velocity.length() > 0 and not isAnimated:
			animated_sprite.speed_scale = 1.0
			animated_sprite.play("walk1")
			animated_sprite.flip_h = velocity.x < 0
		else:
			animated_sprite.play("idle")
	
	if isCharging && hp <= 0:
		queue_free()

func _on_hurtbox_hurt(damage: Variant):
	$HurtSound.play()
	hp -= damage
	var timer = $Timer
	if animated_sprite.modulate != Color(150,0,0,100):
		var tmp = animated_sprite.modulate
		animated_sprite.modulate = Color(150,0,0,100)
		timer.start(0.1)
		await timer.timeout
		animated_sprite.modulate = tmp
	update_health_boss(hp, max_hp)
	if hp <= 0:
		die()
		drop_xp()
		boss_death.emit()

func drop_xp() -> void:
	var num_orbs = randi() % 4 + 2  # Génère un nombre aléatoire entre 2 et 5
	for i in range(num_orbs):
		var xp_orb = preload("res://scenes/xp.tscn").instantiate()
		var random_offset = Vector2(randf() * 60 - 30, randf() * 60 - 30)  # Position aléatoire dans une zone de 60x60 pixels
		xp_orb.global_position = global_position + random_offset
		get_parent().add_child(xp_orb)

func _on_hitbox_body_entered(body: Node2D):
	if body.is_in_group("player"):
		isTouched = true
		$Hitbox/Timer.start()

func _on_timer_timeout():
	if not isAnimated and not isDead:
		isAnimated = true
		animated_sprite.speed_scale = 2.0
		animated_sprite.play("attack1")
		isAnimated = false

func _on_hitbox_body_exited(body: Node2D):
	isTouched = false
	$Hitbox/Timer.stop()

func die():
	isDead = true
	$Hitbox/CollisionShape2D.call_deferred("set","disabled",true)
	
	$CollisionShape2D.call_deferred("set","disabled",true)
	animated_sprite.animation = "dead"
	velocity = Vector2.ZERO
	set_process(false)


func special_attack():
	if hp >= 50:
		chargeSpeAtt()

func chargeSpeAtt():
	isCharging = true
	$Shield.visible = true
	$Hurtbox/CollisionShape2D.disabled = true
	$Hurtbox/Timer.stop()
	var timer = $Timer
	timer.start(2.0)
	_process(false)
	animated_sprite.stop()
	await timer.timeout
	release_attack()
	isCharging = false
	$Shield.visible = false
	$SuperPower.start()

func release_attack():
	var num_rays = 10 * (niveauBoss + 1 * 0.5)
	var angle_step = 360.0 / num_rays
	var safe_angles = []
	
	if num_rays > 40:
		num_rays = 40
		
	var safe_zones = num_rays/5
	
	for i in range(safe_zones):
		safe_angles.append(randf() * 360.0)

	for i in range(num_rays):
		var angle = i * angle_step
		if not is_safe_angle(angle, safe_angles):
			spawn_ray(angle)
	
	$Hurtbox/Timer.start()
	$Hurtbox/CollisionShape2D.disabled = false

func is_safe_angle(angle: float, safe_angles: Array) -> bool:
	for safe_angle in safe_angles:
		if abs(angle - safe_angle) < 15.0:
			return true
	return false

func spawn_ray(angle: float):
	var ray = preload("res://scenes/laser.tscn").instantiate()
	ray.direction = Vector2.RIGHT.rotated(deg_to_rad(angle))
	ray.position = global_position
	get_parent().add_child(ray)

func _on_super_power_timeout() -> void:
	if niveauBoss == 1:
		chargeSpeAtt()
	else:
		for i in range(niveauBoss-1 * 2):
			chargeSpeAtt()


func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite.animation == "dead":
		queue_free()
