extends Area2D

@onready var xp = $"."
@onready var player = %Player
var amount = 10

func _on_body_entered(body):
	if body == player:
		player.add_xp(amount)
		xp.queue_free()
