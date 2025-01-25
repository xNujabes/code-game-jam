extends Area2D

@export var speed = 2.0 
@export var radius = 100.0  # Rayon de l'orbite
@export var damage = 2  # Dégâts infligés aux ennemis
@export var lifetime = 5.0  # Durée de vie du projectile
@export var level = 1
@export var number = 3

var angle = 0.0  # Angle actuel de rotation
var player: Node2D  # Référence au joueur
var timer: Timer  # Timer pour la durée de vie

func _ready() -> void:
	# Trouver le joueur dans la scène
	player = get_tree().get_first_node_in_group("player")
	
	# Configurer la durée de vie
	timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "queue_free"))
	add_child(timer)
	timer.start()
	
	loadLevel()

	# Ajuster l'angle initial en fonction du nombre de projectiles
	var angle_offset = (2 * PI) / number  # Espacement angulaire entre les projectiles
	angle = angle_offset * get_index()  # Chaque projectile a un angle initial différent

func _physics_process(delta: float) -> void:
	if player:
		# Mettre à jour l'angle de rotation
		angle += speed * delta
		
		# Calculer la position orbitale
		var offset = Vector2(cos(angle), sin(angle)) * radius
		position = player.position + offset

func loadLevel():
	match level:
		1:  # Niveau 1
			speed = 2.0
			radius = 100.0
			damage = 2
			lifetime = 5.0
			number = 3

		2:  # Niveau 2
			speed = 2.5
			radius = 120.0
			damage = 3
			lifetime = 6.0
			number = 4

		3:  # Niveau 3
			speed = 3.0
			radius = 140.0
			damage = 4
			lifetime = 7.0
			number = 5

		4:  # Niveau 4
			speed = 3.5
			radius = 160.0
			damage = 5
			lifetime = 8.0
			number = 6

		5:  # Niveau 5
			speed = 4.0
			radius = 180.0
			damage = 6
			lifetime = 9.0
			number = 7
