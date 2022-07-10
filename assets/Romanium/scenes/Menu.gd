extends ViewportContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Viewport/Spatial/Player/AnimationPlayer").get_animation('Spinning').set_loop(true)
	get_node("Viewport/Spatial/Player/AnimationPlayer").play('Spinning')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	get_parent().next_scene()
