extends Area2D

var level = 1
var attackSize = 1.0
@export var hp = 1
@export var speed = 400
@export var damage = 5

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
	match level:
		1:
			hp = 1
			speed = 400
			damage = 5
			attackSize = 1.0

func _physics_process(delta: float) -> void:
	position += angle * speed * delta

func hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
