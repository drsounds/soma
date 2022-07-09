extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_player(player):
	$VirtualJoystick2.player = player

func _on_joy_connection_changed(device_id, connected):
	if connected and OS.has_feature("mobile"):
		self.visible = false
	else:
		self.visible = true
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	if OS.has_feature("mobile"):
		self.visible = true
		
		
		
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
