extends CanvasModulate

const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

signal time_tick(day:int, hour:int, minute:int)

@onready var parallax_bg = $"../ParallaxBackground"  # Adapte ce chemin si nécessaire

@export var gradient:GradientTexture1D
@export var INGAME_SPEED = 5.0
@export var INITIAL_HOUR = 6:
	set(h):
		INITIAL_HOUR = h
		time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR

var time:float = 0.0
var past_minute:float = -1.0

func _ready() -> void:
	time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR

func _process(delta: float) -> void:
	time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
	var value = (sin(time - PI / 2) + 1.0) / 2.0
	self.color = gradient.gradient.sample(value)
	
	# Applique le modulate au ParallaxBackground
	if parallax_bg:
		for layer in parallax_bg.get_children():
			if layer is ParallaxLayer:
				layer.modulate = gradient.gradient.sample(value)
	
	_recalculate_time()
	

func _recalculate_time() -> void:
	var total_minutes = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	var day = int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes = total_minutes % MINUTES_PER_DAY
	var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute = int(current_day_minutes % MINUTES_PER_HOUR)
	
	if past_minute != minute:
		past_minute = minute
		time_tick.emit(day, hour, minute)
