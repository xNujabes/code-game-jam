extends Area2D

@onready var sprites = $AnimatedSprite2D

# Définis des plages pour les dégâts et la vitesse
var min_damage: int = 5
var max_damage: int = 15
var min_speed: float = 250.0
var max_speed: float = 350.0
var niveauBoss = Global.niveauBoss

# Variables pour les dégâts et la vitesse (initialisées aléatoirement)
var damage: int
var speed: float

var direction: Vector2 = Vector2.RIGHT
var max_distance: float = 1000.0  # Distance maximale que le rayon peut parcourir
var distance_traveled: float = 0.0

func _ready():
	# Initialise les dégâts et la vitesse de manière aléatoire
	damage = randi_range(min_damage, max_damage) + 2 * niveauBoss
	speed = randf_range(min_speed, max_speed) * 1.3 
	
	# Oriente le sprite dans la direction du rayon
	rotation = direction.angle()

func _process(delta):
	# Déplace le rayon
	var movement = direction * speed * delta
	position += movement
	distance_traveled += movement.length()
	sprites.play("attack")
	
	# Détruit le rayon s'il a parcouru la distance maximale
	if distance_traveled >= max_distance:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	sprites.play("hit")
	var timerLaser = $Hitbox/Timer

	timerLaser.start(0.3)
	await timerLaser.timeout
	queue_free()
