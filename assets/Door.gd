extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (bool) var is_full_open setget set_is_full_open, get_is_full_open

export (bool) var is_open setget set_is_open, get_is_open

export (bool) var can_open setget set_can_open, get_can_open

# Called when the node enters the scene tree for the first time.
func _ready():
	_create_collision_body(self)

func set_can_open(value):
	can_open = value
	if not can_open:
		is_open = false

func get_can_open():
	return can_open

func set_is_open(value):
	if not can_open:
			return
	if get_node("DoorAnimation") == null:
		return
	is_open = value
	
	if is_open:
		if is_full_open:
			get_node("DoorAnimation").play('OpenFull')
		else:
			get_node("DoorAnimation").play('DoorOpen')
	else:
		
		if is_full_open:
			get_node("DoorAnimation").play('CloseFull')
		else:
			get_node("DoorAnimation").play('DoorClose')

func get_is_full_open():
	return is_full_open

func set_is_full_open(value):
	is_full_open = value

func get_is_open():
	return is_open

func _create_collision_body(node):
	for sub_node in node.get_children():
		if sub_node is MeshInstance:
			sub_node.create_trimesh_collision()
		_create_collision_body(sub_node)


func toggle_open():
	 self.is_open = !self.is_open

func use():
	toggle_open()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
