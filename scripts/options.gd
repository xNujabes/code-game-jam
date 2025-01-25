extends VBoxContainer

var OptionSlot= preload("res://scenes/option_slot.tscn")
const YELLOW_CARD = preload("res://assets/Card/yellowCard.png")
const BLUE_CARD = preload("res://assets/Card/blueCard.png")
var option_slot = OptionSlot.instantiate()

func _ready():
	hide()
	
func close_option():
	hide()
	get_tree().paused =false
	remove_child(option_slot) 

#Gestion des équipements
var weaponPool = [
	{
		"type": "weapon",
		"name": "flute",
		"level": 0,
	}, 
	{
		"type": "weapon",
		"name": "piano",
		"level": 0,
	}, 
	{
		"type": "weapon",
		"name": "drum",
		"level": 0,
	}, 
	{
		"type": "weapon",
		"name": "synth_wave",
		"level": 0,
	}, 
	{
		"type": "weapon",
		"name": "sax",
		"level": 0,
	}
]

var equipementPool = [
	{
		"type": "equipement",
		"name": "sac",
		"level": 0,
	},
	{
		"type": "equipement",
		"name": "casque",
		"level": 0,
	},
	{
		"type": "equipement",
		"name": "micro",
		"level": 0,
	},
	{
		"type": "equipement",
		"name": "claquette",
		"level": 0,
	},
	{
		"type": "equipement",
		"name": "lunettes",
		"level": 0,
	},
]

func majOptionPool(type, name, level):
	match type:
		"equipement":
			for equipement in equipementPool:
				if equipement.name == name:
					equipement.level = level 
		"weapon":
			for weapon in weaponPool:
				if weapon.name == name:
					weapon.level = level 

# Récupère 3 items aléatoirement 
func getRandomOptions():
	randomize()  # Initialiser le générateur de nombres aléatoires
	
	# Combiner les deux pools en un dictionnaire pour accéder facilement
	var pools = {
		"weapon": weaponPool,
		"equipement": equipementPool
	}
	
	var random_array: Array = []

	while random_array.size() < 3:
		# Choisir un type d'objet aléatoire : "weapon" ou "equipement"
		var selected_type = "weapon" if randi() % 2 == 0 else "equipement"
		
		# Obtenir un objet aléatoire dans le pool sélectionné
		var pool = pools[selected_type]
		var random_object = pool[randi() % pool.size()]
		
		# Ajouter l'objet sélectionné au tableau si il n'est pas déjà présent
		if (!(random_object in random_array) && random_object.level < 5):
			random_array.append(random_object)
	
	return random_array

func show_option():
	var types = getRandomOptions()
	
	# Modifie les datas des options
	if YELLOW_CARD and option_slot.has_node("option1") and option_slot.has_node("option2") and option_slot.has_node("option3"):  # Vérifie si le nœud existe
		for i in range(types.size()):
			var option = types[i]
			var texture_button = option_slot.get_node("option" + str(i+1))
			var description = texture_button.get_node("Description") as Label
			var level = texture_button.get_node("Label") as Label
			if option.type == "equipement":
				texture_button.texture_normal = YELLOW_CARD
			else:
				if BLUE_CARD:
					texture_button.texture_normal = BLUE_CARD
				
			description.text = option.name
			level.text = "level : " + str(option.level)	
	
	add_child(option_slot)
	show()
	get_tree().paused = true
	
