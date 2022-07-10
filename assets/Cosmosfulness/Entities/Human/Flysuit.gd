extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var shape = get_node("Flysuit/Flysuit").get_child(0).mesh.create_trimesh_shape()
	get_node("CollisionShape").shape = shape
	pass # Replace with function body.


# Called when there is an input event
func _input(event: InputEvent) -> void:
 
	if event.is_action_pressed("pull"):
		self.add_central_force(Vector3(0, 5, 0))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
