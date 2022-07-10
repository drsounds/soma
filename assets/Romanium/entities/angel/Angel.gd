extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var floating_animation = get_node('AnimationPlayer').get_animation('Floating')
	floating_animation.set_loop(true)
	$AnimationPlayer.play('Floating')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
