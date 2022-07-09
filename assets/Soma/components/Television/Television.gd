extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (ViewportTexture) var viewport setget set_viewport, get_viewport

func set_viewport(value):
	$Screen.get_surface_material(0).set_texture(SpatialMaterial.TEXTURE_ALBEDO, value)
	
func get_viewport():
	return $Screen.get_surface_material(0).get_texture()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
