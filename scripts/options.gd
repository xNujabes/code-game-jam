extends VBoxContainer

var OptionSlot= preload("res://scenes/option_slot.tscn")

func _ready():
	hide()
	
func close_option():
	hide()
	get_tree().paused =false

func show_option():
	var option_slot = OptionSlot.instantiate()
	add_child(option_slot)
	show()
	get_tree().paused = true
