extends Spatial

var agents = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var spawners = []

func assign_spawners():
	for i in range(5):
		var car = get_node('Car' + str(i + 1))
		if not agents.has(car.agent):
			agents.push_back(car.agent)
		car.set_agents(agents)
		var spawn_point = spawners[randi() % spawners.size()]
		car.target_node = spawn_point
		car.start_ai()

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(5):
		spawners.push_back(get_node('Spawn' + str(i + 1)))
	for child in $Lisch.get_children():
		if child is RigidBody:
			var agent = GSAIRigidBody3DAgent.new(child)
	
			self.agents.push_back(agent)
		
		if child is MeshInstance:
			child.create_trimesh_collision()
			for b in child.get_children():
				if b is StaticBody:
					if b != null:
						var agent = GSAIRigidBody3DAgent.new(b)
						self.agents.push_back(agent)
			
	$Water.create_trimesh_collision() 
	#$PlayerCar.respawn()
	#$Camera.current = true 
	#assign_spawners()
	#$Car3.target_node = $Spawn3
	#$Car3.start_ai()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	assign_spawners()
