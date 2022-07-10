extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var timer = Timer.new()
var pos = 0

var animation = []


var current_frame = []

export (int) var wait_time setget  set_wait_time, get_wait_time

export var output_path = ''

var mode = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect('_on_tick', timer, 'tick')
	

func get_wait_time():
	return self.timer.wait_time
	
func set_wait_time(value):
	self.timer.wait_time = value

func _input(event): 
	for action in InputMap.get_actions():
		print(action)
		if Input.is_action_just_pressed(action):
			if action == 'replayer.record':
				record()
			if action == 'replayer.stop':
				stop()
			if action == 'replayer.pause':
				pause()
			if action == 'replayer.resume':
				resume()
		if Input.is_action_just_pressed(action):		
			if mode == 'record':
				current_frame.append({
					'action': event.action,
					'is_pressed': true,
					'type': 'input'
			})
		if Input.is_action_just_released(action):		
			if mode == 'record':
				current_frame.append({
					'action': event.action,
					'is_pressed': false,
					'type': 'input'
			})
	
func record():
	mode = 'record'
	pos = 0
	animation = []
	current_frame = []
	timer.start()
	
func play(position = 0):
	var f := File.new()
	if f.file_exists(output_path):
		mode = 'play' 
		f.open(output_path, File.READ)
		var data = f.read_string() 
		animation = JSON.parse(data)
		
		pos = position
		timer.start()
		
func pause():
	self.timer.stop()

func resume():
	self.timer.start()


func stop():
	timer.stop()
	if mode == 'record':
		var f := File.new()
		f.open(output_path, File.WRITE)
		f.store_string(JSON.print(animation))
		f.close()
	pos = 0

func _on_tick():
	if mode == 'record':
		current_frame = []
		animation.push(current_frame)
		pos = pos + 1
	elif mode == 'play':
		if pos < len(animation):
			var events = animation[pos]
			for event in events:
				if event['type'] == 'input':
					var a = InputEventAction.new()
					a.is_pressed = event['is_pressed']
					a.action = event['action']
					Input.parse_input_event(a)
		else:
			stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
