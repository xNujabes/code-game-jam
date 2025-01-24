extends CanvasLayer

@onready var health_bar = $BarDeVie
@onready var xp_bar = $BarDeXP
@onready var level_label = $LevelLabel
@onready var score_label = $LabelTimeScore
@onready var timer = $TimerScore

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
	
	# Initialiser le Timer pour le score
	if timer:
		timer.connect("timeout", Callable(self, "_on_score_timeout"))
		timer.start()
	update_score_display()

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

func _on_score_timeout() -> void:
	score += 1
	update_score_display()

func update_score_display() -> void:
	var minutes = score / 60
	var seconds = score % 60
	var score_text = ""
	
	if minutes > 0:
		score_text += str(minutes) + " min "
	
	score_text += str(seconds) + " s"
	
	if score_label:
		score_label.text = score_text
