extends Area2D

var level = 1
var attackSize = 1.0
@export var hp = 1
@export var speed = 100
@export var damage = 10
@export var baseAmmo = 1
@export var attackSpeed = 7.5

var target = Vector2.ZERO  # target est déjà un Vector2
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle()
	loadLevel()
	scale = Vector2(attackSize, attackSize)

func _physics_process(delta: float) -> void:
	# Vérifie si la distance entre position et target est très petite (pour éviter des problèmes de précision)
	if position.distance_to(target) > 1.0:  # 1.0 est une tolérance, vous pouvez l'ajuster
		position += angle * speed * delta
		$PianoBlink.play()
	else:
		$AnimatedSprite2D.play("Blink")
		if $Timer.is_stopped():
			$Timer.start()

func explode():
	$CollisionShape2D.disabled = false
	$Explosion.visible = true
	$PianoExplosion.play()
	$Explosion.play("explode")
	$ExplosionTimer.start()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	explode()

func _on_explosion_timer_timeout() -> void:
	queue_free()

func loadLevel():
	match level:
		1:  # Niveau 1
			hp = 1
			speed = 100
			damage = 10
			attackSize = 1.0
			baseAmmo = 1
			attackSpeed = 7.5

		2:  # Niveau 2
			hp = 2
			speed = 120
			damage = 15
			attackSize = 1.2
			baseAmmo = 1
			attackSpeed = 7.0

		3:  # Niveau 3
			hp = 3
			speed = 140
			damage = 20
			attackSize = 1.4
			baseAmmo = 2
			attackSpeed = 6.5

		4:  # Niveau 4
			hp = 4
			speed = 160
			damage = 25
			attackSize = 1.6
			baseAmmo = 2
			attackSpeed = 6.0

		5:  # Niveau 5
			hp = 5
			speed = 180
			damage = 30
			attackSize = 1.8
			baseAmmo = 3
			attackSpeed = 5.5
