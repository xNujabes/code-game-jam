extends CanvasLayer

@onready var health_bar = $BarDeVie2
@onready var xp_bar = $BarD_XP
@onready var level_label = $LevelLabel

func _ready() -> void:
	if health_bar:
		health_bar.max_value = 100
		health_bar.value = 100
	if xp_bar:
		xp_bar.max_value = 100
		xp_bar.value = 0
	if level_label:
		level_label.text = str(1)

func update_health(current_hp, max_hp):
	if health_bar:
		health_bar.value = current_hp
		health_bar.max_value = max_hp

func update_xp(current_xp, max_xp, level):
	if xp_bar:
		xp_bar.value = current_xp
		xp_bar.max_value = max_xp
	if level_label:
		level_label.text = str(level)
