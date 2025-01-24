extends CharacterBody2D

@export var speed = 40.0
@export var hp = 10

var isAnimated = false
var isTouched = false

@onready var player = get_tree().get_first_node_in_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		queue_free()

#zombie animé si une collision sur sa hitbox
func _on_hitbox_body_entered(body: Node2D):
	print(isTouched)
	print("qkdjqzoijdqzpd")
	isTouched = true
	$Hitbox/Timer.start()
	

#attack toute les Timer sec
func _on_timer_timeout():
	if not isAnimated:
		isAnimated = true
		$AnimatedSprite2D.play("attack1")
		isAnimated = false
	

func _on_hitbox_body_exited(body: Node2D):
	$Hitbox/Timer.stop()
	isTouched = false
