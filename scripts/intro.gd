extends Node2D

@onready var loading_bar = $LoadingBar  # Référence à la barre de chargement
var is_loading = false  # Indicateur de chargement en cours
var loading_paths = [
	"res://scenes/scene_start.tscn",  # Scène principale à charger
	"res://scenes/Main.tscn"         # Scène imbriquée à précharger
]
var loading_tasks = []  # Liste des tâches de chargement
var loaded_scenes = {}  # Dictionnaire des scènes chargées
var progress_data = []  # Liste des tableaux de progression individuels
var total_progress = 0.0
var completed_tasks = 0

func _ready():
	start_loading()
	$AnimationPlayer.play("Fade in")
	await get_tree().create_timer(1.5).timeout
	$AnimationPlayer.play("Fade out")
	await get_tree().create_timer(1.5).timeout


func _process(delta):
	if is_loading:

		# Vérification de chaque tâche de chargement
		for i in range(loading_tasks.size()):
			var progress = progress_data[i]
			var status = ResourceLoader.load_threaded_get_status(loading_paths[i], progress)
			total_progress += progress[0]  # Calcul de la progression totale

			# Traitement en fonction de l'état du chargement
			if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
				if not loaded_scenes.has(loading_paths[i]):
					loaded_scenes[loading_paths[i]] = ResourceLoader.load_threaded_get(loading_paths[i])
				completed_tasks += 1
			elif status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
				is_loading = false
				return

		# Mise à jour de la barre de progression
		var normalized_progress = total_progress / loading_tasks.size()

		# Convertir en pourcentage et limiter la valeur entre 0 et 100
		var progress_percentage = clamp(normalized_progress, 0, 100)

		# Mettre à jour la barre de progression
		loading_bar.value = progress_percentage
		# Si toutes les scènes sont chargées, on termine le processus
		if completed_tasks >= loading_tasks.size():
			is_loading = false
			loading_bar.visible = false
			$Label.visible = true
			
	elif completed_tasks != 0:
		if Input.is_anything_pressed():
				on_loading_complete()

func start_loading():
	is_loading = true
	loading_bar.value = 0

	for path in loading_paths:
		var progress = [0.0]  # Initialisation de la progression de chaque scène
		progress_data.append(progress)

		var error = ResourceLoader.load_threaded_request(path)
		if error == OK:
			loading_tasks.append(path)

func on_loading_complete():
	var start_scene = loaded_scenes["res://scenes/scene_start.tscn"].instantiate()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(start_scene)
	get_tree().current_scene = start_scene
	# Associer la scène Main à la scène Start
	start_scene.game = loaded_scenes["res://scenes/Main.tscn"]
