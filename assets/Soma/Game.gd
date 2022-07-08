extends ViewportContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Viewport/SceneManager.go_to_scene("Level1", "Start")

func go_to_scene(scene_id, spawn_id):
	$Viewport/SceneManager.go_to_scene(scene_id, spawn_id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
