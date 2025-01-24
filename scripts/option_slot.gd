extends HBoxContainer

var weapon = null  # Déclare une variable pour stocker l'arme associée

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
		$option1/Description.text = "very cool"
		$option2/Label.text = "Lvl 1"
		$option2/Description.text = "very cool"
		$option3/Label.text = "Lvl 1"
		$option3/Description.text = "very cool"
 
func _on_gui_input(event : InputEvent):
	if event.is_action_pressed("click") :
		#weapon.upgrade_item()
		get_parent().close_option()


func _on_option_1_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") :
		#weapon.upgrade_item()
		get_parent().close_option()


func _on_option_2_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") :
		#weapon.upgrade_item()
		get_parent().close_option()


func _on_option_3_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") :
		#weapon.upgrade_item()
		get_parent().close_option()
