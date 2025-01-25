extends CanvasLayer

@onready var health_bar = $BarDeVie
@onready var xp_bar = $BarDeXP
@onready var level_label = $LevelLabel
@onready var weapons_container = $Inventory/Weapons
@onready var equipment_container = $Inventory/Equipment  # Ajoute une référence au conteneur des équipements

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

		for weapon_name in weapons:
			var weapon_data = weapons[weapon_name]
			if weapon_data["level"] > 0:
				var weapon_icon = TextureRect.new()
				var texture = load_texture("res://assets/weapons/{weapon_name}.png".format({"weapon_name": weapon_name}))
				if texture:
					weapon_icon.texture = texture
				weapon_icon.expand = true
				weapon_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				weapon_icon.custom_minimum_size = Vector2(32, 32)  # Taille minimale
				weapon_icon.visible = true

				var weapon_level = Label.new()
				weapon_level.text = str(weapon_data["level"])

				var weapon_container = HBoxContainer.new()
				weapon_container.add_child(weapon_icon)
				weapon_container.add_child(weapon_level)
				weapon_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # S'étendre horizontalement

				weapons_container.add_child(weapon_container)

func update_equipment(equipment: Dictionary):
	if equipment_container:
		for child in equipment_container.get_children():
			child.queue_free()

		for equip_name in equipment:  # Correction ici : "equip_name" au lieu de "equap_name"
			var equip_data = equipment[equip_name]
			if equip_data["level"] > 0:
				var equip_icon = TextureRect.new()
				var texture = load_texture("res://assets/Equipement/{equip_name}.png".format({"equip_name": equip_name}))
				if texture:
					equip_icon.texture = texture
				equip_icon.expand = true
				equip_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				equip_icon.custom_minimum_size = Vector2(32, 32)  # Taille minimale
				equip_icon.visible = true

				var equip_level = Label.new()
				equip_level.text = str(equip_data["level"])

				var equip_container = HBoxContainer.new()
				equip_container.add_child(equip_icon)
				equip_container.add_child(equip_level)
				equip_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # S'étendre horizontalement

				equipment_container.add_child(equip_container)

func load_texture(path: String) -> Texture2D:
	var texture = load(path)
	if texture and texture.get_width() > 0 and texture.get_height() > 0:
		return texture
	else:
		print("Erreur : Impossible de charger l'image à partir du chemin : ", path)
		return load("res://chemin/vers/image_par_defaut.png")  # Image de remplacement
