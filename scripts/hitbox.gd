extends Area2D

@export var damage = 1

@onready var collision = $CollisionShape2D
@onready var timer = $Timer


func tempDisable():
	collision.call_deferred("set","disabled",true)
	timer.start()


func _on_timer_timeout() -> void:
	collision.call_deferred("set","disabled",false)
