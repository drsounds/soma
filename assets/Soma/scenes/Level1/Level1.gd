extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var medium = null

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.propagate_call("set_flag", [0, false])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
