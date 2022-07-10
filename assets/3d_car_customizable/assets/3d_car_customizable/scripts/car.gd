extends VehicleBody

var target_node : Spatial setget set_target_node, get_target_node
export(bool) var is_ai 
onready var collision := $CollisionShape
onready var agent = GSAIRigidBody3DAgent.new(self)
onready var target = GSAIAgentLocation.new()
onready var accel = GSAITargetAcceleration.new()
onready var blend = GSAIBlend.new(agent)
onready var face = GSAIFace.new(agent, target, true)
onready var arrive = GSAIArrive.new(agent, target)
onready var proximity := GSAIRadiusProximity.new(agent, [], 140)
onready var avoid := GSAIAvoidCollisions.new(agent, proximity)
onready var seek := GSAISeek.new(agent, target)
onready var priority := GSAIPriority.new(agent, 0.0001)
var SettingspanelPath = preload("../scenes/settings.tscn")
var mouseDelta = Vector2()

var boundaries: Vector3

# Camera variables

export(bool) var use_camera = true
var lookSensitivity = 0.1
var minLookAngle = -130.0
var maxLookAngle = 25.0
var followCameraAngle = 20
var camera_onoff = true
var cameraTimerSecond = 2
onready var cameraTimer = 0
var cameraOrbit
var followCameraY = 1
var previous_velocity = Vector3(0, 0, 0)
var current_velocity = Vector3(0, 0, 0)
var player = null
var passengers = []
var driver  
# Car variables

var is_paralyzed = false

var back_camera_front
export(bool) var use_controls = false
export(bool) var show_settings = true
export(bool) var create_default_player = true
export(bool) var ai_driver = false
# These become just placeholders if presets are in use
var MAX_ENGINE_FORCE =  413.0
var MAX_BRAKE = 100.0
var MAX_STEERING = 0.5
var STEERING_SPEED = 7

var jump_force = 0.0

export (float, 0, 100, 5) var linear_speed_max := 60.0 setget set_linear_speed_max
export (float, 0, 100, 0.1) var linear_acceleration_max := 26.0 setget set_linear_acceleration_max
export (float, 0, 50, 0.1) var arrival_tolerance := 20.5 setget set_arrival_tolerance
export (float, 0, 50, 0.1) var deceleration_radius := 1118.0 setget set_deceleration_radius
export (int, 0, 1080, 10) var angular_speed_max := 270 setget set_angular_speed_max
export (int, 0, 2048, 10) var angular_accel_max := 145 setget set_angular_accel_max
export (int, 0, 178, 2) var align_tolerance := 55 setget set_align_tolerance
export (int, 0, 180, 2) var angular_deceleration_radius := 345 setget set_angular_deceleration_radius

onready var camera = get_node('Camera')

export(int) var camera_mode = 0 setget set_camera_mode, get_camera_mode


var draw_proximity: bool

var _boundary_right: float
var _boundary_bottom: float
var _radius: float
var _accel := GSAITargetAcceleration.new()
var _velocity := Vector2.ZERO
var _direction := Vector2()
var _drag := 0.1
var _color := Color(0.4, 1.0, 0.89, 0.3)

################################################
################## Car Script ##################
################################################

func set_agents(agents):
	self.proximity.agents = agents

func set_target_node(value):
	target_node = value

func get_target_node():
	return target_node

func set_align_tolerance(value: int) -> void:
	align_tolerance = value
	if not is_inside_tree():
		return

	self.face.alignment_tolerance = deg2rad(value)


func set_angular_deceleration_radius(value: int) -> void:
	deceleration_radius = value
	if not is_inside_tree():
		return

	self.face.deceleration_radius = deg2rad(value)


func set_angular_accel_max(value: int) -> void:
	angular_accel_max = value
	if not is_inside_tree():
		return

	self.agent.angular_acceleration_max = deg2rad(value)


func set_angular_speed_max(value: int) -> void:
	angular_speed_max = value
	if not is_inside_tree():
		return

	self.agent.angular_speed_max = deg2rad(value)


func set_arrival_tolerance(value: float) -> void:
	arrival_tolerance = value
	if not is_inside_tree():
		return

	self.arrive.arrival_tolerance = value


func set_deceleration_radius(value: float) -> void:
	deceleration_radius = value
	if not is_inside_tree():
		return

	self.arrive.deceleration_radius = value


func set_linear_speed_max(value: float) -> void:
	linear_speed_max = value
	if not is_inside_tree():
		return

	self.agent.linear_speed_max = value


func set_linear_acceleration_max(value: float) -> void:
	linear_acceleration_max = value
	if not is_inside_tree():
		return

	self.agent.linear_acceleration_max = value
	
func setup_ai():
	
	var rng := RandomNumberGenerator.new()
	self.setup_arriver(
		deg2rad(align_tolerance),
		deg2rad(angular_deceleration_radius),
		deg2rad(angular_accel_max),
		deg2rad(angular_speed_max),
		deceleration_radius,
		arrival_tolerance,
		linear_acceleration_max,
		linear_speed_max,
		target_node
	)
	self.setup_avoider(
			linear_speed_max,
			linear_acceleration_max,
			22,
			22,
			22,
			true,
			rng
		)

func setup_avoider(
	linear_speed_max: float,
	linear_accel_max: float,
	proximity_radius: float,
	boundary_right: float,
	boundary_bottom: float,
	_draw_proximity: bool,
	rng: RandomNumberGenerator
) -> void:
	rng.randomize()
	_direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()

	agent.linear_speed_max = linear_speed_max
	agent.linear_acceleration_max = linear_accel_max

	proximity.radius = proximity_radius
	_boundary_bottom = boundary_bottom
	_boundary_right = boundary_right

	_radius = 33 # collision.shape.radius
	agent.bounding_radius = _radius

	agent.linear_drag_percentage = _drag

	self.draw_proximity = _draw_proximity

	priority.add(avoid)
	priority.add(seek)


func setup_arriver(
	align_tolerance: float,
	angular_deceleration_radius: float,
	angular_accel_max: float,
	angular_speed_max: float,
	deceleration_radius: float,
	arrival_tolerance: float,
	linear_acceleration_max: float,
	linear_speed_max: float,
	_target: Spatial
) -> void:
	agent.linear_speed_max = linear_speed_max
	agent.linear_acceleration_max = linear_acceleration_max
	agent.linear_drag_percentage = 0.05
	agent.angular_acceleration_max = angular_accel_max
	agent.angular_speed_max = angular_speed_max
	agent.angular_drag_percentage = 0.1

	arrive.arrival_tolerance = arrival_tolerance
	arrive.deceleration_radius = deceleration_radius

	face.alignment_tolerance = align_tolerance
	face.deceleration_radius = angular_deceleration_radius

	target_node = _target
	self.target.position = target_node.transform.origin
	blend.add(arrive, 1)
	blend.add(face, 1)

func set_camera_mode(value):
	camera_mode = value
	if camera != null:
		camera.current = false
	if camera_mode == 0:
		camera = $CameraFront
	elif camera_mode == 1:
		camera = $Camera
	if camera != null:
		camera.current = true

func get_camera_mode():
	return camera_mode

func toggle_camera():
	if camera_mode == 1:
		set_camera_mode(0)
	else:
		set_camera_mode(1)


func _ready():
	self.bounce = 1
	set_contact_monitor(true)
	set_max_contacts_reported(10000)
	set_camera_mode(camera_mode)
	back_camera_front = $CameraBackFront
	#remove_child(back_camera_front)
	# get_parent().add_child(back_camera_front)
	if create_default_player:
		var player_class = load('res://assets/Player/player.tscn')
		self.player = player_class.instance()
		self.player.transform = self.transform
		self.player.is_player = true
		self.player.can_fly = true
		get_into_car(player, true)

	# A camera node is attached if `Use Camera is checked
	if(use_camera):
		cameraOrbit = Spatial.new()
		var aCameraNode : Camera = Camera.new()
		aCameraNode.translate(Vector3(0, 0, 0))
		aCameraNode.rotation_degrees.y = 180
		# You can change the camera position here
		# It is currently placed on the hood
		cameraOrbit.translate(Vector3(0, 0.6, 0.4))
		cameraOrbit.add_child(aCameraNode)
		aCameraNode.far = 11000
		add_child(cameraOrbit)
		
		# When the scene starts, the mouse disappeares
		# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# ..and the Settingspanel gets instanced
	var SettingsPanel = SettingspanelPath.instance()
	SettingsPanel.visible = false
	SettingsPanel.CarNode = self
	call_deferred("add_child", SettingsPanel) 

func start_ai():
	self.is_ai = true
	if self.is_ai:
		setup_ai()

func body_entered(node):
	pass

var kill_timer = null

func _on_kill_timeout():
	respawn()
	if kill_timer:
		kill_timer.stop()
		remove_child(kill_timer)
		kill_timer = null

func jump():
	self.linear_velocity.y += 3

func horn():
	pass

func _physics_process(delta):
	if self.is_ai:
		target.position = target_node.transform.origin
		target.position.y = transform.origin.y
		blend.calculate_steering(accel)
		agent._apply_steering(accel, delta)
		
	if not $rear_left.is_in_contact() and not $rear_right.is_in_contact() and not $front_left.is_in_contact() and not $front_right.is_in_contact():
		if not kill_timer:		
			kill_timer = Timer.new()
			add_child(kill_timer)
			kill_timer.one_shot = true
			kill_timer.wait_time = 5
			kill_timer.connect("timeout", self, "_on_kill_timeout")
			kill_timer.start()
	else:
		if kill_timer:
			kill_timer.stop()
			remove_child(kill_timer)
			kill_timer = null			
	var parts = [$rear_left, $rear_right, self, $front_right, $front_left]
	for part in parts:
		var bodies = get_colliding_bodies()
		for body in bodies:
			if body.get_parent():
				if body.get_parent().name.find('Water', 0) != -1:
					if not is_paralyzed:
						paralyze()
	# This variable turns the camera when the car turns
	followCameraY = 0
	var horizontal_velocity = Vector2(current_velocity.x, current_velocity.z)

	if horizontal_velocity.length_squared() > 0 and not $EngineSound.playing:
		$EngineSound.play(0)
	$EngineSound.pitch_scale = (horizontal_velocity.length_squared() / 2000 + 0.5) 
	# If user wants to control the car
	if((is_paralyzed) or not self.driver or not self.driver.is_player):
		return
	if Input.is_action_pressed("ui_respawn"):
		respawn()
	var steer_val = 0.0
	var throttle_val = 0.0
	var brake_val = 0.0
	if Input.is_action_pressed('disembark'):
		if self.driver and self.driver in self.passengers:
			get_out_of_car(self.driver)
	if Input.is_action_pressed("ui_up"):
		throttle_val = 1.0
	if Input.is_action_pressed("ui_down"):
		throttle_val = -0.5
	if Input.is_action_pressed("ui_select"):
		brake_val = 1.0
	if Input.is_action_pressed("ui_left"):
		steer_val = 1.0
		if(use_camera): followCameraY = 10
	if Input.is_action_pressed("ui_right"):
		steer_val = -1.0
		if(use_camera): followCameraY = -10
	if Input.is_action_pressed("ui_horn"):
		horn()
	if Input.is_action_pressed("jump"):
		jump()
	if Input.is_action_just_pressed("toggle_camera"):
		toggle_camera()
	
	if Input.is_action_just_pressed("ui_cancel"):
		# Show or hide the Settingspanel with pressing ESC
		if (show_settings):
			if(get_node("Settings").visible):
				get_node("Settings").visible = false
				camera_onoff = !camera_onoff
			else:
				get_node("Settings").visible = true
				camera_onoff = !camera_onoff
		# Show/hide the mouse with pressing ESC if there is a camera attached to the car
		if (use_camera and false):
			if(Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE):
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	engine_force = throttle_val * MAX_ENGINE_FORCE
	brake = brake_val * MAX_BRAKE
	
	
	# Using lerp for a smooth steering
	steering = lerp(steering, -steer_val * MAX_STEERING, STEERING_SPEED * delta)
	
	if self.linear_velocity.y > 1:
		self.linear_velocity.y -= 1
	previous_velocity = current_velocity
	current_velocity = self.linear_velocity
	
	
	var up = self.transform.origin
	up.z += 2   
	
################################################
################# Camera Script ################
################################################

func respawn(spawn_point = null):
	var spawn_points = []
	for child in get_parent().get_children():
		if child.name.find('Spawn', 0) != -1:
			spawn_points.append(child)
	if spawn_points.size() > 0:
		if spawn_point == null:
			spawn_point = spawn_points[randi() % spawn_points.size()]
		self.transform = spawn_point.transform
		
	self.rotation_degrees = Vector3(0, 0, 0)
	self.steering = 0
	self.engine_force = 0
	self.linear_velocity.x = 0
	self.linear_velocity.y = 0
	self.linear_velocity.z = 0
	self.brake = 0
	is_paralyzed = false

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func paralyze():
	var timer = Timer.new()
	self.add_child(timer)
	timer.wait_time = 1
	timer.one_shot = true
	timer.connect("timeout", self, "_paralyze_expire")
	timer.start()
	is_paralyzed = true

func _paralyze_expire():
	respawn()

func _process(delta):
	# If user wants to use the car camera
	if(!use_camera ):
		return
	
	var rot = Vector3(mouseDelta.y, mouseDelta.x, 0) * lookSensitivity
	
	# Checking if the Settingspanel is active or not
	if(camera_onoff):
		# If the mouse is moving then camera turns around the car
		if(mouseDelta != Vector2()):
			cameraOrbit.rotation_degrees.x = clamp(cameraOrbit.rotation_degrees.x, minLookAngle, maxLookAngle)
			cameraOrbit.rotation_degrees.x -= rot.x
			cameraOrbit.rotation_degrees.y -= rot.y
			
			# ..and the timer gets activated so that the
			# camera doesn't follow the car for the duration of the timer
			cameraTimer = cameraTimerSecond
		
		if(cameraTimer > 0):
			cameraTimer -= delta
		else:
			
			# If the timer is up / mouse did not move for the duration of the timer
			# The camera smoothly moves to the follow position
			cameraOrbit.rotation_degrees.x = lerp(cameraOrbit.rotation_degrees.x, followCameraAngle, delta * 10)
			cameraOrbit.rotation_degrees.y = lerp(cameraOrbit.rotation_degrees.y, followCameraY, delta * 10)
	# Recorded mouse positions are being deleted
	# so that we can capture the next movement
	mouseDelta = Vector2()

func _on_Car_body_entered(body): 
	current_velocity = self.linear_velocity
	var crash_intensity = vector3_get_max(current_velocity)
	if body is VehicleBody:
		var body_crash_intensity = vector3_get_max(body.linear_velocity)
		if true: # crash_intensity > body_crash_intensity:
			#if current_velocity.max_axis() == Vector3.AXIS_X:
			var x_force = current_velocity.x  	 	 
			var z_force = current_velocity.z  	 	 
			body.engine_force=0 
			self.apply_central_impulse(Vector3(x_force, 0, z_force))	
			body.apply_central_impulse(Vector3(-x_force * 90, 0, -z_force * 90))	
	if crash_intensity >= 1:
		if not $GlassCrashSound.playing:
			$GlassCrashSound.play()
		else:
			if not $BigCrashSound.playing:
				$BigCrashSound.play()

func get_out_of_car(passenger):
	if not passenger in self.passengers:
		pass
	self.get_parent().add_child(passenger) 
	engine_force = 0 
	
	passenger.transform = self.transform
	passenger.transform.origin.x -= 5
	passenger.rotation_degrees.x = 0
	passenger.rotation_degrees.y = 0
	passenger.rotation_degrees.z = 0
	if passenger.is_player:
		use_camera = false
		use_controls = false
		show_settings = false
		$Camera.current = false 
		self.driver = null
		
		passenger.get_node('Camroot/h/v/pivot/Camera').current = true
		passenger.is_embarked = false
		passenger.is_player = true
		# get_parent().remove_child(self)
		print("Disembarked player")
	self.passengers.erase(passenger)

func get_into_car(passenger, is_driver=false):
	self.passengers.append(passenger)
	if is_driver:
		self.driver = passenger
	if passenger.is_player:
		self.use_camera = true
		self.use_controls = true
		self.show_settings = true
		$Camera.current = false 
	self.get_parent().remove_child(passenger)
func use(node):
	get_into_car(node, true)

func vector3_get_max(v3):
	if v3.max_axis() == Vector3.AXIS_X:
		return v3.x
	if v3.max_axis() == Vector3.AXIS_Y:
		return v3.y
	if v3.max_axis() == Vector3.AXIS_Z:
		return v3.z

