extends Area2D

var level = 1
var attackSize = 1.0
@export var hp = 1
@export var speed = 600
@export var damage = 2
@export var baseAmmo = 6
@export var attackSpeed = 4

var target = Vector2.ZERO
var angle = Vector2.ZERO
var direction = Vector2.ZERO  # Ajout de la propriété direction

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	if direction != Vector2.ZERO:
		angle = direction
	else:
		angle = global_position.direction_to(target)
	rotation = angle.angle()
	loadLevel()
	scale = Vector2(attackSize, attackSize)

func _physics_process(delta: float) -> void:
	position += angle * speed * delta

func hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func loadLevel():
	match level:
		1:  # Niveau 1
			hp = 1
			speed = 200
			damage = 2
			attackSize = 1.0
			baseAmmo = 6
			attackSpeed = 4


		2:  # Niveau 2
			hp = 1
			speed = 225
			damage = 3
			attackSize = 1.2
			baseAmmo = 7
			attackSpeed = 3.5


		3:  # Niveau 3
			hp = 1
			speed = 250
			damage = 4
			attackSize = 1.5
			baseAmmo = 8
			attackSpeed = 3.0


		4:  # Niveau 4
			hp = 1
			speed = 275
			damage = 5
			attackSize = 1.8
			baseAmmo = 9
			attackSpeed = 2.5


		5:  # Niveau 5 (niveau maximal)
			hp = 2
			speed = 300
			damage = 6
			attackSize = 2.0
			baseAmmo = 10
			attackSpeed = 2.0
