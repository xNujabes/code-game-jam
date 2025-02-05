extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D

@export var speed = 20.0
@export var hp = 10
@export var xp_amount = 15
var direction
var isTouched
var isAnimated

@onready var player = get_tree().get_first_node_in_group("player")

# Appelée lorsque le nœud entre dans la scène pour la première fois.
func _ready() -> void:
	direction = global_position.direction_to(player.global_position)

# Appelée à chaque frame. 'delta' est le temps écoulé depuis la précédente frame.
func _process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

func _on_hurtbox_hurt(damage: Variant) -> void:
	$HurtSound.play()
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

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.

#zombie animé si une collision sur sa hitbox
func _on_hitbox_body_entered(body: Node2D):
	if body.is_in_group("player") :
		isTouched = true
		$Hitbox/Timer.start()
		
#attack toute les Timer sec
func _on_timer_timeout():
	if not isAnimated :
		isAnimated = true
		$AnimatedSprite2D.play("attack1")
		isAnimated = false
	

func _on_hitbox_body_exited(body: Node2D):
	isTouched = false
	$Hitbox/Timer.stop()
		
func die():
	# Change l'animation à "dead"
	animated_sprite.animation = "dead"
	velocity = Vector2.ZERO  # Arrête tout mouvement
	set_process(false)  # Arrête le traitement si nécessaire


func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite.animation == "dead":
		queue_free()  # Supprime le monstre
		
		
