extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (String) var code setget set_code, get_code

func set_code(value):
	code = value
	
func get_code():
	return code

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func use(target):
	target.door_keys.append(self.code)
	self.get_parent().remove_child(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
