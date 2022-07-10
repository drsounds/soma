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
var crouch_walk_speed = 0.001
var run_speed = 0.05
var acceleration = 2.4
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
	 
	var h_rot = self.global_transform.basis.get_euler().y
 
	if Input.is_action_pressed("forward") ||  Input.is_action_pressed("backward") ||  Input.is_action_pressed("left") ||  Input.is_action_pressed("right"):
		print(Input.get_action_strength("forward") * 100 )
		direction = Vector3(
			Input.get_action_strength("left") - Input.get_action_strength("right"),
			0,
			(Input.get_action_strength("forward") - Input.get_action_strength("backward"))
		)

		strafe_dir = direction	
		var v = move_and_slide(direction * 1000)

func set_show_hood(value):
	$Head/Camera/Hood.visible = value

func get_show_hood():
	return $Head/Camera/Hood.visible
