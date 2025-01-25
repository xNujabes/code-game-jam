extends Node

var fire_mode = "Auto"  # Valeur par défaut
var is_muted = false  
var day = 0
var hour = 0
var minute = 0

# Le meilleur score est stocké sous forme de jour, heure, et minute
var best_score = {"day": 0, "hour": 0, "minute": 0}

func set_daytime(new_day: int, new_hour: int, new_minute: int) -> void:
	day = new_day
	hour = new_hour
	minute = new_minute

func update_best_score(current_day: int, current_hour: int, current_minute: int) -> void:
	# Compare le meilleur score actuel avec le nouveau score
	var best = best_score
	if current_day > best.day or \
		(current_day == best.day and current_hour > best.hour) or \
		(current_day == best.day and current_hour == best.hour and current_minute > best.minute):
		best_score.day = current_day
		best_score.hour = current_hour
		best_score.minute = current_minute

func _ready():
	pass
