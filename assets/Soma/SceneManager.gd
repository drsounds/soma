extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var fading = 0

var pending_spawn_id = null
var pending_scene_id = null

var scene = null

var medium = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 1.00

func fade_out():
	fading = -1
	$FadeTimer.start()


func fade_in():
	fading = +1
	$FadeTimer.start()

func go_to_scene(scene_id, spawn_id):
	pending_scene_id = scene_id
	#fade_out()
	load_scene(scene_id, spawn_id)
	self.pending_spawn_id = spawn_id

func load_scene(scene_id, spawn_id):
	
	if scene:
		self.remove_child(scene)
	var Scene = load('res://assets/Soma/scenes/' + scene_id + '/' + scene_id + '.tscn')

	scene = Scene.instance()
	#scene.modulate.a = 0.00
	self.add_child(scene)
	
	var spawn = scene.get_node('Spawn_' + spawn_id)
	
	var PlayerScene = load('res://assets/Player/Player.tscn')
	var player = PlayerScene.instance()
	
	scene.add_child(player)
	if spawn:
		player.global_transform.origin.x = spawn.global_transform.origin.x
		player.global_transform.origin.y = spawn.global_transform.origin.y
		player.global_transform.origin.z = spawn.global_transform.origin.z
	
	var mobile_controls = self.get_parent().find_node("MobileControls*")
	if mobile_controls:
		mobile_controls.set_player(player)
	var medium = scene.medium
	player.set_medium(medium)
		
	#self.fade_in()

func _on_FadeTimer_timeout():
	if fading < 0:
		if self.modulate.a < 0.01:
			fading = 0
			$FadeTimer.stop()
			if pending_scene_id:
				load_scene(pending_scene_id, pending_spawn_id)
		self.modulate.a -= 0.01
	if fading > 0:
		if self.modulate.a > 0.99:
			fading = 0
			$FadeTimer.stop()
		self.modulate.a += 0.01
