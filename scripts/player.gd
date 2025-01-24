extends CharacterBody2D

@export var speed = 50.0
@export var hp = 80
@export var max_hp = 80

@export var xp = 0
@export var xp_to_level_up = 100
@export var max_xp = 100

@export var level = 1

@onready var hud = get_tree().get_first_node_in_group("HUD")

#Armes
var bullet = preload("res://scenes/bullet.tscn")

@onready var bulletTimer = get_node("Weapons/BulletTmer")
@onready var bulletAttackTimer = get_node("Weapons/BulletTmer/BulletAttackTimer")

var bulletAmmo = 0
var bulletBaseAmmo = 1
var bulletAttackSpeed = 1.5
var bulletLevel = 1


#Camera animation
@onready var animation_player = $AnimationPlayer

#Targeting systeù

var enemyClose = []

# Appelée lorsque le nœud entre dans la scène pour la première fois.
func _ready() -> void:
	attack()
	update_hud()

# Appelée à chaque frame. 'delta' est le temps écoulé depuis la précédente frame.
func _physics_process(delta: float) -> void:
	move()
	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.play("idle")

func move():
	var x_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_dir = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_dir, y_dir)
	velocity = mov.normalized() * speed
	move_and_slide()

func attack():
	if bulletLevel > 0:
		bulletTimer.wait_time = bulletAttackSpeed
		if bulletTimer.is_stopped():
			bulletTimer.start()

func _on_hurtbox_hurt(damage: Variant) -> void:
	hp -= damage
	if hp < 0:
		hp = 0
	animation_player.play("camera-shake")
	print(hp)
	update_hud()

func add_xp(amount):
	xp += amount
	if xp >= xp_to_level_up:
		xp -= xp_to_level_up
		level += 1
		xp_to_level_up *= level
		max_xp = xp_to_level_up
		print("LEVEL UP ", level)
		%Options.show_option()
	update_hud()

func update_hud():
	if hud:
		hud.update_health(hp, max_hp)
		hud.update_xp(xp, max_xp, level)

func _on_bullet_tmer_timeout() -> void:
	bulletAmmo += bulletBaseAmmo
	bulletAttackTimer.start()

func _on_bullet_attack_timer_timeout() -> void:
	if bulletAmmo > 0:
		var bulletAttack = bullet.instantiate()
		bulletAttack.position = position
		bulletAttack.target = get_random_target()
		bulletAttack.level = bulletLevel
		add_child(bulletAttack)
		bulletAmmo -= 1
		$Weapons/BulletSound.play()
		if bulletAmmo > 0:
			bulletAttackTimer.start()
		else:
			bulletAttackTimer.stop()
		
func get_random_target():
	if enemyClose.size() > 0:
		print(enemyClose.pick_random().global_position)
		return enemyClose.pick_random().global_position
	else:
		return Vector2.UP

func _on_range_detection_body_entered(body: Node2D) -> void:
	if not enemyClose.has(body):
		enemyClose.append(body)

func _on_range_detection_body_exited(body: Node2D) -> void:
	if enemyClose.has(body):
		enemyClose.erase(body)
