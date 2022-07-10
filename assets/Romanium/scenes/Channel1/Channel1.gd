extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Clock2D._time = 19 * 1800 + 60 * 59 + 55
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if get_parent() != null:
		if get_parent().has_method('next_scene'):
			get_parent().next_scene()
