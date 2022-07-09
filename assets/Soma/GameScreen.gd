extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var window_size = OS.get_real_window_size()
	if window_size.x > window_size.y:
		var GameScene = load('res://assets/Soma/GameLandscape.tscn')
		var game_scene = GameScene.instance()
		self.add_child(game_scene)
	else:
		var GameScene = load('res://assets/Soma/GamePortrait.tscn')
		var game_scene = GameScene.instance()
		self.add_child(game_scene)
		OS.window_size = Vector2(1080, 2340)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
