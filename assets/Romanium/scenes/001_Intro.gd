extends ViewportContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_feature('JavaScript'):
		JavaScript.eval("""
			window.parent.postMessage({
				type: 'action',
				position: 0,
				duration: 0
			})
		""")
	pass # Replace with function body.
	# $Viewport/Spatial/WorldEnvironment/SpaceAnimation.play('Space')
	# $Angel2/AnimationPlayer.play('Floating')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SyndiBox_section_finished(cur_section):
	"""
	if cur_section == 3:
		get_node("Angel/AnimationPlayer").stop()
		get_node("AudioStreamPlayer/AudioStreamBreaker").play('ChewTape')
		get_node("Viewport/Spatial/WorldEnvironment/DarkForce").play('DarkForce')
	if cur_section == 4:
		get_parent().next_scene()
"""


func _on_Button_pressed():
	get_tree().change_scene('res://assets/Romanium/scenes/Television')


func _on_VideoPlayer_finished():
	
	$Control/VideoPlayer.play()


func _on_Button2_pressed():
	get_parent().new_game()
