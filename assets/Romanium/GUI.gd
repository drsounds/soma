 extends Control

signal position_changed(pos)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_pos(index):
	$HSlider.value = (index)
	$SeekPrevious.disabled = index < 1
	$SeekForward.disabled =  index > get_duration() - 1
	
func get_pos():
	return $HSlider.value

func set_duration(duration):
	$HSlider.max_value = duration

func get_duration():
	return $HSlider.max_value



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HSlider_value_changed(value):
	emit_signal('position_changed', value)



func _on_SeekPrevious_pressed():
	emit_signal('position_changed', get_pos() - 1)
	pass # Replace with function body.


func _on_SeekForward_pressed():
	emit_signal('position_changed', get_pos() + 1)
