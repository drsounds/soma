extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (String) var entrance_code setget set_entrance_code, get_entrance_code

export (bool) var is_entrance_locked setget set_is_entrance_locked, get_is_entrance_locked

func get_entrance_code():
	return get_node("Bungalow").entrance_code
	
func set_entrance_code(value):
	get_node("Bungalow").entrance_code = value 

func get_is_entrance_locked():
	return get_node("Bungalow").is_entrance_locked
	
func set_is_entrance_locked(value):
	get_node("Bungalow").is_entrance_locked = value 



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
