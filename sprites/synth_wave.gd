extends Area2D

var level = 1
@export var damage = 2
@export var radius = 200.0  # Taille fixe de la wave
@export var duration = 2.0  # Durée de vie de la wave
@export var speed = 0.0  # La wave ne se déplace pas, donc speed = 0

var player: Node2D  # Référence au joueur
var timer: Timer  # Timer pour la durée de vie

func _ready() -> void:
	# Trouver le joueur dans la scène
	player = get_tree().get_first_node_in_group("player")
	
	# Configurer la taille de la wave
	$CollisionShape2D.shape.radius = radius
	$Sprite2D.scale = Vector2(radius / 100, radius / 100)  # Ajuster l'échelle du sprite
	
	# Démarrer le timer pour la durée de vie
	timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "queue_free"))
	add_child(timer)
	timer.start()
	
	loadLevel()

func _physics_process(delta: float) -> void:
	# Mettre à jour la position de la wave pour suivre le joueur
	if player:
		position = player.position

func loadLevel():
	match level:
		1:  # Niveau 1
			damage = 2
			radius = 200.0
			duration = 2.0
			speed = 0.0

		2:  # Niveau 2
			damage = 3
			radius = 220.0
			duration = 2.5
			speed = 0.0

		3:  # Niveau 3
			damage = 4
			radius = 240.0
			duration = 3.0
			speed = 0.0

		4:  # Niveau 4
			damage = 5
			radius = 260.0
			duration = 3.5
			speed = 0.0

		5:  # Niveau 5
			damage = 6
			radius = 280.0
			duration = 4.0
			speed = 0.0
