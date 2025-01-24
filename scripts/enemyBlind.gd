extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D

@export var speed = 20.0
@export var hp = 10
@export var xp_amount = 15
var direction
var isTouched
var isAnimated

@onready var player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = global_position.direction_to(player.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()


func _on_hurtbox_hurt(damage: Variant) -> void:
	hp -= damage
	print(hp)
	if hp < 0:
		queue_free()
		
func drop_xp() -> void:
	var xp = preload("res://scenes/xp.tscn").instantiate()
	xp.amount = xp_amount
	add_child(xp)


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
		
		
