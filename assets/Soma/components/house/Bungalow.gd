extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (String) var entrance_code setget set_entrance_code, get_entrance_code

export (bool) var is_entrance_locked setget set_is_entrance_locked, get_is_entrance_locked

func get_entrance_code():
	return get_node("EntranceDoor").code
	
func set_entrance_code(value):
	get_node("EntranceDoor").code = value 

func get_is_entrance_locked():
	return get_node("EntranceDoor").is_locked
	
func set_is_entrance_locked(value):
	get_node("EntranceDoor").is_locked = value 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	for child in get_children():
		if child is MeshInstance:
			child.create_trimesh_collision()
		for sub_child in child.get_children():
			if sub_child is MeshInstance:
				sub_child.create_trimesh_collision()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
