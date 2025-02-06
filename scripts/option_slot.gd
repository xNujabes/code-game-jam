extends HBoxContainer

@export var weapon = null  

@onready var player = get_tree().get_first_node_in_group("player")


func applyBonus(bonusName):
	match bonusName:
		"claquette":
			player.speed += 50
		"casque":
			player.max_hp += 50
			player.hp += 50
		"lunettes":
			var cam = player.get_node("Camera2D")
			cam.zoom -= Vector2(0.1,0.1)
			var range = player.get_node("RangeDetection")
			range.scale += Vector2(0.05,0.05)

func _on_option_1_gui_input(event: InputEvent) -> void:
	var description = $option1/Description

	if event.is_action_pressed("click") :
		#weapon.upgrade_item()
		if isWeapon(description.text):
			player.levelUpWeapon(description.text)
		else:
			applyBonus(description.text)
			player.levelUpEquipement(description.text)
		get_parent().close_option()


func _on_option_2_gui_input(event: InputEvent) -> void:
	var description = $option2/Description

	
	if event.is_action_pressed("click") :
		#weapon.upgrade_item()
		if isWeapon(description.text):
			player.levelUpWeapon(description.text)
		else:
			applyBonus(description.text)
			player.levelUpEquipement(description.text)
		get_parent().close_option()


func _on_option_3_gui_input(event: InputEvent) -> void:
	var description = $option3/Description
	
	if event.is_action_pressed("click") :
		#weapon.upgrade_item()
		if isWeapon(description.text):
			player.levelUpWeapon(description.text)
		else:
			applyBonus(description.text)
			player.levelUpEquipement(description.text)
		get_parent().close_option()
		
func isWeapon(name) :
	return name == "flute" || name == "piano" || name == "synth_wave" || name == "sax" || name == "drum"|| name == "bullet"
