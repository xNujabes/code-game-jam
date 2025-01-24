extends Area2D

@export_enum('cooldown', 'hitOnce', 'disableHitbox') var hurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var timer = $Timer

signal hurt(damage)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('attack'):
		if not area.get("damage") == null:

			match hurtBoxType:
				0:  # cooldown
					collision.call_deferred("set", "disabled", true)
					timer.start()
				1:  # hitOnce
					pass
				2:  # disableHitbox
					if area.has_method('tempDisable'):
						area.tempDisable()
						
			var damage = area.damage
			emit_signal("hurt", damage)
			if area.has_method("hit"):
				area.hit(1)

func _on_timer_timeout() -> void:
	collision.call_deferred("set", "disabled", false)
