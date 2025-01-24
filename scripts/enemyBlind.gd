extends CharacterBody2D

@export var speed = 40.0
@export var hp = 10
@export var xp_amount = 15
var direction

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
	if hp < 0:
		queue_free()
		
func drop_xp() -> void:
	var xp = preload("res://scenes/xp.tscn").instantiate()
	xp.amount = xp_amount
	add_child(xp)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
