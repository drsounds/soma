extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (float) var time setget set_time, get_time

var _time = 0.0

func get_time():
	return _time
	
func set_time(value):
	_time = value
	var seconds = fmod(_time, 60)
	var minutes = fmod(_time, 3600) / 60.0
	var hours = (_time / 3600)
	print(str(floor(hours)) + ":" + str(floor(minutes)) + ":" + str(floor(seconds)))
	
	var hours_rotation = ((hours / 12.0) * 360.0) 
	var minutes_rotation = ((minutes / 60.0) * 360.0) 
	var seconds_rotation = ((seconds / 60) * 360.0)
	
	$Clock/Minute.set_rotation_degrees(minutes_rotation)
	$Clock/Hour.set_rotation_degrees(hours_rotation)
	$Clock/Second.set_rotation_degrees(seconds_rotation)

	print(str(hours_rotation) + 'deg:' + str(minutes_rotation) + 'deg:' + str(seconds_rotation) + 'deg')


# Called when the node enters the scene tree for the first time.
func _ready():
	# Print hour tick
	for i in range(60.0):
		var newTick = $BG/Tick.duplicate()
		newTick.get_child(0).rect_size.y -= 6
		newTick.get_child(0).rect_size.x -= 9
		print(i)
		var degrees = (float(i) / 60.0) * 360
		print(degrees)
		newTick.set_rotation_degrees(degrees)
		$BG.add_child(newTick)
	pass # Replace with function body.

	for i in range(12.0):
		var newTick = $BG/Tick.duplicate()
		print(i)
		var degrees = (float(i) / 12.0) * 360
		print(degrees)
		newTick.set_rotation_degrees(degrees)
		$BG.add_child(newTick)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	set_time(_time + 1)
