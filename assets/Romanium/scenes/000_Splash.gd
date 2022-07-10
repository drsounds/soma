extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SyndiBox_section_finished(cur_section):
	pass


func _on_SyndiBox_signal_tag(identifier):
	if identifier == 'next':
		get_parent().next_scene()
