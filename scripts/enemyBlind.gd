extends CharacterBody2D

@export var speed = 40.0
@export var hp = 10
@export var xp_amount = 15
var direction

@onready var player = get_tree().get_first_node_in_group("player")

# Appelée lorsque le nœud entre dans la scène pour la première fois.
func _ready() -> void:
	direction = global_position.direction_to(player.global_position)

# Appelée à chaque frame. 'delta' est le temps écoulé depuis la précédente frame.
func _process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

func _on_hurtbox_hurt(damage: Variant) -> void:
	hp -= damage
	print(hp)
	if hp < 0:
		drop_xp()
		queue_free()

func drop_xp() -> void:
	var num_orbs = randi() % 4 + 2  # Génère un nombre aléatoire entre 2 et 5
	for i in range(num_orbs):
		var xp_orb = preload("res://scenes/xp.tscn").instantiate()
		var random_offset = Vector2(randf() * 60 - 30, randf() * 60 - 30)  # Position aléatoire dans une zone de 60x60 pixels
		xp_orb.global_position = global_position + random_offset
		get_parent().add_child(xp_orb)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
