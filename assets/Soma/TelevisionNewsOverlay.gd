extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var title = "" setget set_title, get_title


# Called when the node enters the scene tree for the first time.
func _ready():
	_render_time()

func get_title():
	return $TitleLabel.text

func set_title(value):
	$TitleLabel.text = value

func get_headline():
	return $HeadlineLabel.text

func set_headline(value):
	$HeadlineLabel.text = value

func get_text():
	return $TextLabel.text

func set_text(value):
	$TextLabel.text = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _render_time():
	var time = OS.get_datetime()
	$ClockLabel.text = "%02d:%02d" % [time['hour'], time['minute']]

func _on_Timer_timeout():
	_render_time()	
