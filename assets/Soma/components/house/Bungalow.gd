extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (String) var entrance_code
export (bool) var is_entrance_locked

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
