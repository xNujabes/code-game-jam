extends VBoxContainer

var OptionSlot= preload("res://scenes/option_slot.tscn")
const YELLOW_CARD = preload("res://assets/Card/yellowCard.png")
const BLUE_CARD = preload("res://assets/Card/blueCard.png")
var option_slot = OptionSlot.instantiate()
const TEXTURES = {
	"flute": preload("res://assets/Weapons/flute.png"),
	"piano": preload("res://assets/weapons/piano.png"),
	"drum": preload("res://assets/Weapons/drum.png"),
	"synth_wave": preload("res://assets/weapons/synth_wave.png"),
	"sax": preload("res://assets/weapons/sax.png"),
	"casque": preload("res://assets/Equipement/Casque.png"),
	"claquette": preload("res://assets/Equipement/claquette.png"),
	"lunettes": preload("res://assets/Equipement/lunettes.png"),
}

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
		"description" : "Envoie des guitare",
		"level": 0,
	}, 
	{
		"type": "weapon",
		"name": "piano",
		"description" : "Sorte de grenade",
		"level": 0,
	}, 
	{
		"type": "weapon",
		"name": "drum",
		"description" : "Bouclier de tamboure",
		"level": 0,
	}, 
	{
		"type": "weapon",
		"name": "synth_wave",
		"description" : "ceinture de protection",
		"level": 0,
	}, 
	{
		"type": "weapon",
		"name": "sax",
		"description" : "mitrayelle de trompettte",
		"level": 0,
	}
]

var equipementPool = [
	{
		"type": "equipement",
		"name": "casque",
		"description" : "regains de pv",
		"level": 0,
	},
	{
		"type": "equipement",
		"name": "claquette",
		"description" : "augmente la vitesse",
		"level": 0,
	},
	{
		"type": "equipement",
		"name": "lunettes",
		"description" : "augmente la vision",
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
	
	if YELLOW_CARD and option_slot.has_node("option1") and option_slot.has_node("option2") and option_slot.has_node("option3"):
		for i in range(types.size()):
			var option = types[i]
			var texture_button = option_slot.get_node("option" + str(i+1))
			var description = texture_button.get_node("Description") as Label
			var level = texture_button.get_node("Label") as Label
			var texture = texture_button.get_node("TextureRect") as TextureRect
			var item_description = texture_button.get_node("ItemDescription") as Label
			
			# Check if the node exists before assigning the text property
			if item_description:
				item_description.text = option.description  # Définir la description de l'objet
			
			# Définir la texture en fonction du nom de l'objet
			if option.name in TEXTURES:
				texture.texture = TEXTURES[option.name]
				texture.expand = true  # Force l'image à remplir le TextureRect
				texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED  # Redimensionne l'image pour couvrir le rectangle
			
			# Définir la couleur de la carte
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
