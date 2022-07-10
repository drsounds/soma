extends Node

var next_scene = "";

var scenes = [
	"assets/Romanium/scenes/Channel1/Channel1",
	"assets/Romanium/scenes/004_Transition",
	"assets/Romanium/scenes/005_Utopology",
	"assets/Romanium/scenes/004_Transition",
	"assets/Romanium/scenes/003_orphaned",
	"assets/Romanium/scenes/006_transition",
	"assets/Romanium/scenes/SpaceFortress/SpaceFortress",
	"assets/Romanium/scenes/006_transition",
	"assets/Romanium/scenes/Orphanage/Orphanage",	
	"assets/Romanium/scenes/006_transition",
	"assets/Romanium/scenes/Graditanita/Graditanita",	
	"assets/Romanium/scenes/006_transition",
	"assets/Romanium/scenes/SpaceFortress/SpaceFortress",
	"assets/Romanium/scenes/SpaceFortress/Utopology",
]

func get_pos():
	return self.get_gui().get_pos()



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func get_gui():
	return get_parent().get_node('GUI')

# Called when the node enters the scene tree for the first time.
func _ready():
	set_pos(0)
	set_duration(scenes.size() - 1)

func set_duration(duration):
	get_gui().set_duration(duration)

func set_pos(index, notified=false):
	var scene_name = scenes[index]
	set_scene(scene_name)
	if not notified:
		get_gui().set_pos(index)

func get_current_scene():
	if self.get_child_count() > 0:
		return self.get_child(0)
	return null

func fade_in():
	$FadeInTimer.start()

func set_scene(name):
	next_scene = name
	get_parent().get_parent().start_fade_out()
	

func _set_scene(name):
	var root = self
	if root.get_child_count() > 0:
		if root.has_method('remove_child'):
			root.remove_child(root.get_child(0))
	# Add the next level
	var next_level_resource = load("res://" + name + ".tscn")
	var next_level = next_level_resource.instance()
	root.add_child(next_level)

func _on_GUI_position_changed(pos):
	set_pos(pos, false)

func next_scene():
	if get_pos() < get_gui().get_duration():
		set_pos(get_pos() + 1)
	
func previous_scene():
	if get_pos() > 0:
		set_pos(get_pos() - 1)

func new_game():
	set_pos(0)

  


func _on_Game_on_fade_complete():
	_set_scene(self.next_scene)
	get_parent().get_parent().start_fade_in()
