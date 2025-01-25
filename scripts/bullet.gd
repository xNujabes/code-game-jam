extends Area2D

var level = 1
var attackSize = 1.0
@export var hp = 3
@export var speed = 400
@export var damage = 5
@export var baseAmmo = 1
@export var attackSpeed = 1.5

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
			speed = 400
			damage = 5
			attackSize = 1.0
			baseAmmo = 1
			attackSpeed = 1.5

		2:  # Niveau 2
			hp = 1
			speed = 450
			damage = 7
			attackSize = 1.1
			baseAmmo = 1
			attackSpeed = 1.4

		3:  # Niveau 3
			hp = 2
			speed = 500
			damage = 9
			attackSize = 1.2
			baseAmmo = 1
			attackSpeed = 1.3

		4:  # Niveau 4
			hp = 2
			speed = 550
			damage = 11
			attackSize = 1.3
			baseAmmo = 1
			attackSpeed = 1.2

		5:  # Niveau 5
			hp = 3
			speed = 600
			damage = 13
			attackSize = 1.4
			baseAmmo = 1
			attackSpeed = 1.1
