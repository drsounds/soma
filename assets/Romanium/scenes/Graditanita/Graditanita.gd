extends Spatial

#-----------------SCENE--SCRIPT------------------#
#    Close your game faster by clicking 'Esc'    #
#   Change mouse mode by clicking 'Shift + F1'   #
#------------------------------------------------#

export var fast_close := true
var mouse_mode: String = "CAPTURED"

##################################################
var shader = preload("res://shaders/psx.shader")

func _apply_shader(_node):
	return
	for node in _node.get_children():
		if node is MeshInstance:
			for i in range(node.get_surface_material_count()):
				var material : Material = node.get_surface_material(i)
				material
				var shader_material = ShaderMaterial.new()
				shader_material.set_shader_param("texture1", material.get)
		_apply_shader(node)

func _ready() -> void:
	if fast_close:
		print("** Fast Close enabled in the 's_main.gd' script **")
		print("** 'Esc' to close 'Shift + F1' to release mouse **")
	_apply_shader(self)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$AudioStreamPlayer.seek(300)
	$Television.viewport = $TelevisionViewport
	$TelevisionViewport.world = self.get_world() 
	$TelevisionViewport/Camera.current = true
	# $Player2/AnimationPlayer2.play('Test') 
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and fast_close:
		get_tree().quit() # Quits the game
	
	if event.is_action_pressed("mouse_input") and fast_close:
		match mouse_mode: # Switch statement in GDScript
			"CAPTURED":
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				mouse_mode = "VISIBLE"
			"VISIBLE":
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				mouse_mode = "CAPTURED"
