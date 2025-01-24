extends HBoxContainer

@export var weapon = null  # Déclare une variable pour stocker l'arme associée


func _ready():
	
	# Initialise les valeurs par défaut ou celles d'une arme si définie
	if weapon:
		$option1/Label.text = "Lvl " + str(weapon.level)
		$option1/Description.text = weapon.description
		$option2/Label.text = "Lvl " + str(weapon.level)
		$option2/Description.text = weapon.description
		$option3/Label.text = "Lvl " + str(weapon.level)
		$option3/Description.text = weapon.description
	else:
		$option1/Label.text = "Lvl 1"
		$option2/Label.text = "Lvl 1"
		$option3/Label.text = "Lvl 1"

@onready var player = get_tree().get_first_node_in_group("player")

func applyBonus(bonusName):
	match bonusName:
		"claquette":
			player.speed += 50
		"casque":
			player.max_hp += 20
		"lunettes":
			var cam = player.get_node("Camera2D")
			cam.zoom -= Vector2(0.1,0.1)

func _on_option_1_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") :
		#weapon.upgrade_item()
		print("click")
		applyBonus($option1/Description.text)
		get_parent().close_option()


func _on_option_2_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") :
		#weapon.upgrade_item()
		applyBonus($option2/Description.text)
		get_parent().close_option()


func _on_option_3_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") :
		#weapon.upgrade_item()
		applyBonus($option3/Description.text)
		get_parent().close_option()
