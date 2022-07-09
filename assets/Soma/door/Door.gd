extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (bool) var is_full_open setget set_is_full_open, get_is_full_open

export (bool) var is_open setget set_is_open, get_is_open

export (bool) var can_open setget set_can_open, get_can_open

export (String) var code setget set_code, get_code

export (bool) var is_locked setget set_is_locked, get_is_locked

func set_is_locked(value):
	is_locked = value
	
func get_is_locked():
	return is_locked

func set_code(value):
	code = value
	
func get_code():
	return code

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
	
	if get_node("DoorAnimation") == null:
		return
	
	if value:
		if not can_open or is_locked:
			return
		get_node("DoorAnimation").play('DoorOpen')
	else:
		get_node("DoorAnimation").play('DoorClose')
	is_full_open = value
	is_open = value

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

func unlock():
	self.is_locked = false
	self.is_open = true

func toggle_open():
	if self.is_open:
		self.is_open = false
	else:
		self.is_open = true

func use(target):
	if not is_locked:
		toggle_open()
		return
	if code != null:
		if target.door_keys.has(code):
			self.unlock()
			toggle_open()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
