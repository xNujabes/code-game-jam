extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

@export var speed = 20.0
@export var hp = 100
@export var damage = 200

var isAnimated = false
var isTouched = false
var isDead = false
var isCharging = false
var niveau

@onready var player = get_tree().get_first_node_in_group("player")

signal boss_death


func _ready() -> void:
	special_attack()

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	if not isTouched and not isCharging:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		
		if velocity.length() > 0 and not isAnimated:
			animated_sprite.speed_scale = 1.0
			animated_sprite.play("walk")
			animated_sprite.flip_h = velocity.x < 0
		else:
			animated_sprite.play("idle")



func _on_hurtbox_hurt(damage: Variant):
	if not isCharging:
		hp -= damage
		var timer = $Timer
		var tmp = animated_sprite.modulate
		animated_sprite.modulate = Color(150,0,0,100)
		timer.start(0.3)
		await timer.timeout
		animated_sprite.modulate = tmp

		if hp < 0:
			die()
			drop_xp()
			boss_death.emit()
			queue_free()

func drop_xp() -> void:
	var num_orbs = randi() % 4 + 2  # Génère un nombre aléatoire entre 2 et 5
	for i in range(num_orbs):
		var xp_orb = preload("res://scenes/xp.tscn").instantiate()
		var random_offset = Vector2(randf() * 60 - 30, randf() * 60 - 30)  # Position aléatoire dans une zone de 60x60 pixels
		xp_orb.global_position = global_position + random_offset
		get_parent().add_child(xp_orb)


#zombie animé si une collision sur sa hitbox
func _on_hitbox_body_entered(body: Node2D):
	if body.is_in_group("player") :
		isTouched = true
		$Hitbox/Timer.start()
		
		
#attack toute les Timer sec
func _on_timer_timeout() :
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
	# Change l'animation à "dead"
	animated_sprite.animation = "dead"
	velocity = Vector2.ZERO  # Arrête tout mouvement
	set_process(false)  # Arrête le traitement si nécessaire


func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite.animation == "dead":
		queue_free()  # Supprime le monstre
		
func special_attack():
	if hp >= 50:
		chargeSpeAtt()
		
func chargeSpeAtt():
	isCharging = true  # Active l'état de charge
	var timer = $Timer
	timer.start(2.0)
	_process(false)
	await timer.timeout
	release_attack()
	print("spawn")
	isCharging = false  # Desactive l'état de charge
	var timer2 = $Timer
	timer2.start(2.0)
	await timer2.timeout
	$SuperPower.start()


func release_attack():
	# Crée des rayons circulaires avec des zones sûres
	var num_rays = 60  # Nombre de rayons
	var angle_step = 360.0 / num_rays
	var safe_zones = 4  # Nombre de zones sûres
	var safe_angles = []
	
	# Génère des angles aléatoires pour les zones sûres
	for i in range(safe_zones):
		safe_angles.append(randf() * 360.0)

	for i in range(num_rays):
		var angle = i * angle_step
		if not is_safe_angle(angle, safe_angles):
			spawn_ray(angle)
		
	

func is_safe_angle(angle: float, safe_angles: Array) -> bool:
	for safe_angle in safe_angles:
		if abs(angle - safe_angle) < 15.0:  # Tolérance de 15 degrés pour les zones sûres
			return true
	return false
	
	

func spawn_ray(angle: float):
	var ray = preload("res://scenes/laser.tscn").instantiate()
	ray.direction = Vector2.RIGHT.rotated(deg_to_rad(angle))
	ray.position = global_position
	get_parent().add_child(ray)


func _on_super_power_timeout() -> void:
	chargeSpeAtt()
