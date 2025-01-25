extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

@export var base_speed = 40.0  # Vitesse de base pour le niveau 1
@export var base_hp = 10  # Points de vie de base pour le niveau 1
@export var hp_growth = 2.5  # Augmentation des points de vie par niveau
@export var speed_growth = 2.5  # Augmentation de la vitesse par niveau

var niveauBoss = Global.niveauBoss
var speed : float
var hp : int

var isAnimated = false
var isTouched = false
var isDead = false

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	# Ajuster les statistiques en fonction du niveau du boss
	hp = base_hp + niveauBoss * hp_growth
	speed = base_speed + niveauBoss * speed_growth

func _process(delta: float) -> void:
	if not isTouched:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		if velocity.length() > 0 and not isAnimated:
			animated_sprite.speed_scale = 1.0
			if velocity.x > 0:
				animated_sprite.play("walkL")
			else:
				animated_sprite.play("walkR")

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
	if hp < 0:
		drop_xp()
		die()

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
		var timer = $Timer
		timer.start(0.3)
		_process(false)
		await timer.timeout
		
func _on_hitbox_body_exited(body: Node2D):
	isTouched = false
	$Hitbox/Timer.stop()

func die():
	isDead = true
	animated_sprite.animation = "dead"
	velocity = Vector2.ZERO
	set_process(false)

func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite.animation == "dead":
		queue_free()
