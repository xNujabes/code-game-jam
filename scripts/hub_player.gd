extends CanvasLayer

@onready var health_bar = $BarDeVie
@onready var xp_bar = $BarDeXP
@onready var level_label = $LevelLabel
@onready var weapons_container = $Inventory/Weapons  

var score = 0

func _ready() -> void:
	if health_bar:
		health_bar.max_value = 80
		health_bar.value = 80
	if xp_bar:
		xp_bar.max_value = 100
		xp_bar.value = 0
	if level_label:
		level_label.text = "1  Level"
	

func update_health(current_hp, max_hp):
	if health_bar:
		health_bar.value = current_hp
		health_bar.max_value = max_hp

func update_xp(current_xp, max_xp, level):
	if xp_bar:
		xp_bar.value = current_xp
		xp_bar.max_value = max_xp
	if level_label:
		level_label.text = str(level) + "  Level"


func update_weapons(weapons: Dictionary):
	if weapons_container:

		for child in weapons_container.get_children():
			child.queue_free()

		# Afficher les nouvelles armes
		for weapon_name in weapons:
			var weapon_data = weapons[weapon_name]
			if weapon_data["level"] > 0:  # Afficher uniquement les armes débloquées
				var weapon_label = Label.new()
				weapon_label.text = "{weapon_name} (Niveau {level})".format({
					"weapon_name": weapon_name,
					"level": weapon_data["level"]
				})
				weapons_container.add_child(weapon_label)
