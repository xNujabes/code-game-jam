extends CharacterBody2D

@export var speed = 50.0
@export var hp = 80

@export var xp = 0
var xp_to_level_up = 100

@export var level = 0

@onready var hud =  get_tree().get_first_node_in_group("HUD")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move()

func move():
	var x_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_dir = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_dir,y_dir)
	velocity = mov.normalized() * speed
	move_and_slide()


func _on_hurtbox_hurt(damage: Variant) -> void:
	hp -= damage
	
func add_xp(amount):
	xp += amount
	
