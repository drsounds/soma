extends KinematicBody

###################-VARIABLES-####################

# Camera
export(float) var mouse_sensitivity = 12.0
export(NodePath) var head_path
export(NodePath) var cam_path
export(float) var FOV = 80.0
export(bool) var show_hood setget set_show_hood, get_show_hood
var mouse_axis := Vector2()
# Move
var velocity := Vector3()
var direction := Vector3()
var move_axis := Vector2()
var sprint_enabled := true
var sprinting := false
# Walk
const FLOOR_NORMAL := Vector3(0, 1, 0)
const FLOOR_MAX_ANGLE: float = deg2rad(46.0)
export(int) var sprint_speed = 16
export(int) var deacceleration = 10
export(float, 0.0, 1.0, 0.05) var air_control = 0.3
export(int) var jump_height = 10
# Fly
export(int) var fly_speed = 10
export(int) var fly_accel = 4
export(bool)var flying := false
var gravity = 0
var strafe_dir = 0
var aim_transition = 0
var crouch_stand_target = 0
var vertical_velocity = 0

var weight_on_ground = 5

var movement_speed = 0
var walk_speed = 2.2
var crouch_walk_speed = 1
var run_speed = 5
var acceleration = 6
var angular_acceleration = 7
# Called when the node enters the scene tree
func _ready() -> void:
	randomize()
	var arvr_interface = ARVRServer.find_interface("Native mobile")
	if arvr_interface and arvr_interface.initialize():
		get_viewport().arvr = true
	direction = Vector3.BACK.rotated(Vector3.UP, $Head.global_transform.basis.get_euler().y)
	# Sometimes in the level design you might need to rotate the Player object itself
	# So changing the direction at the beginning
	set_physics_process(true)
	#$AnimationTree.set(wdd"parameters/walk_scale/scale", walk_speed)
	#switch_weapon(0)
	#$splatters.set_as_toplevel(true)

func _physics_process(delta) -> void:
	 
	acceleration = 5
	 
	var h_rot = self.global_transform.basis.get_euler().y
 
	if Input.is_action_pressed("forward") ||  Input.is_action_pressed("backward") ||  Input.is_action_pressed("left") ||  Input.is_action_pressed("right"):
		
		direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"),
					0,
					Input.get_action_strength("forward") - Input.get_action_strength("backward"))

		strafe_dir = direction
		
		direction = direction.rotated(Vector3.UP, h_rot).normalized()
		
		if sprinting && $AnimationTree.get(aim_transition) == 1 && crouch_stand_target:
			movement_speed = run_speed
		else:
			if crouch_stand_target:
				movement_speed = walk_speed
			else:
				movement_speed = crouch_walk_speed
	
	velocity = lerp(velocity, direction * movement_speed, 1 * acceleration)
 
	var v = move_and_slide(velocity + Vector3.UP * vertical_velocity - get_floor_normal() * weight_on_ground, Vector3.UP)
	
func _input(event):
	if event.is_action_pressed("use"):
		for node in self.get_parent().get_children():
			if node is Spatial:
				var distance = self.get_global_transform().origin.distance_to(node.get_global_transform().origin)
				if distance < 5:
					if node.has_method('use'):
						node.use()

func walk(delta: float) -> void:
	# Input
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if move_axis.x >= 0.5:
		direction -= aim.z
	if move_axis.x <= -0.5:
		direction += aim.z
	if move_axis.y <= -0.5:
		direction -= aim.x
	if move_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	# Jump
	var _snap: Vector3
	if true:
		_snap = Vector3(0, -1, 0)
		if Input.is_action_just_pressed("move_jump"):
			_snap = Vector3(0, 0, 0)
			velocity.y = jump_height
	
	# Apply Gravity
	velocity.y -= gravity * delta
	
	# Sprint
	var _speed: int
	if (Input.is_action_pressed("move_sprint") and can_sprint() and move_axis.x >= 0.5):
		_speed = sprint_speed
		sprinting = true
	else:
		_speed = walk_speed
		sprinting = false
	
	# Acceleration and Deacceleration
	# where would the player go
	var _temp_vel: Vector3 = velocity
	_temp_vel.y = 0
	var _target: Vector3 = direction * _speed
	var _temp_accel: float
	if direction.dot(_temp_vel) > 0:
		_temp_accel = acceleration
	else:
		_temp_accel = deacceleration
	if not is_on_floor():
		_temp_accel *= air_control
	# interpolation
	_temp_vel = _temp_vel.linear_interpolate(_target, _temp_accel * delta)
	velocity.x = _temp_vel.x
	velocity.z = _temp_vel.z
	# clamping (to stop on slopes)
	if direction.dot(velocity) == 0:
		var _vel_clamp := 0.25
		if velocity.x < _vel_clamp and velocity.x > -_vel_clamp:
			velocity.x = 0
		if velocity.z < _vel_clamp and velocity.z > -_vel_clamp:
			velocity.z = 0
	
	# Move
	var moving = move_and_slide_with_snap(velocity, _snap, FLOOR_NORMAL, true, 4, FLOOR_MAX_ANGLE)
	if is_on_wall():
		velocity = moving
	else:
		velocity.y = moving.y


func fly(delta: float) -> void:
	"""
	# Input
	direction = Vector3()
	var aim = head.get_global_transform().basis
	if move_axis.x >= 0.5:
		direction -= aim.z
	if move_axis.x <= -0.5:
		direction += aim.z
	if move_axis.y <= -0.5:
		direction -= aim.x
	if move_axis.y >= 0.5:
		direction += aim.x
	direction = direction.normalized()
	
	# Acceleration and Deacceleration
	var target: Vector3 = direction * fly_speed
	velocity = velocity.linear_interpolate(target, fly_accel * delta)
	
	# Move
	velocity = move_and_slide(velocity)
	"""

func camera_rotation() -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if mouse_axis.length() > 0:
		var horizontal: float = -mouse_axis.x * (mouse_sensitivity / 100)
		var vertical: float = -mouse_axis.y * (mouse_sensitivity / 100)
		
		mouse_axis = Vector2()
		
		rotate_y(deg2rad(horizontal))
		#head.rotate_x(deg2rad(vertical))
		
		# Clamp mouse rotation
		#var temp_rot: Vector3 = head.rotation_degrees
		#temp_rot.x = clamp(temp_rot.x, -90, 90)
		#head.rotation_degrees = temp_rot

func can_sprint() -> bool:
	return (sprint_enabled and is_on_floor())

func set_show_hood(value):
	$Head/Camera/Hood.visible = value

func get_show_hood():
	return $Head/Camera/Hood.visible
