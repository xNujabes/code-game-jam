extends CharacterBody2D

@export var speed = 40.0
@export var hp = 10

var isAnimated = false
var isTouched = false

@onready var player = get_tree().get_first_node_in_group("player")

# Appelée à chaque frame. 'delta' est le temps écoulé depuis la précédente frame.
func _process(delta: float) -> void:
	if not isTouched:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		if velocity.length() > 0 and not isAnimated:
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.play("idle")

func _on_hurtbox_hurt(damage: Variant):
	hp -= damage
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

func _on_hitbox_body_entered(body: Node2D):
	if body.is_in_group("player"):
		isTouched = true
		$Hitbox/Timer.start()

func _on_timer_timeout():
	if not isAnimated:
		isAnimated = true
		$AnimatedSprite2D.play("attack1")
		isAnimated = false

func _on_hitbox_body_exited(body: Node2D):
	isTouched = false
	$Hitbox/Timer.stop()
