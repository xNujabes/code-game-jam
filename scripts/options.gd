extends VBoxContainer

var OptionSlot= preload("res://scenes/option_slot.tscn")
var option_slot = OptionSlot.instantiate()

func _ready():
	hide()
	
func close_option():
	hide()
	get_tree().paused =false
	remove_child(option_slot)
	

func show_option():
	add_child(option_slot)
	show()
	get_tree().paused = true
	
