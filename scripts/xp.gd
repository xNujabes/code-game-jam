extends Area2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var amount = 10
@export var attraction_radius = 200
@export var attraction_speed = 300
var is_collected = false


func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	if player and not is_collected:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player <= attraction_radius:
			# Déplacer vers le joueur
			var direction = (player.global_position - global_position).normalized()
			global_position += direction * attraction_speed * delta
		if distance_to_player < 10:
			collect_xp()

func collect_xp():
	is_collected = true
	player.add_xp(amount)
	print("XP taken ", player.xp)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		collect_xp()
