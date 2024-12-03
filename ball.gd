extends RigidBody2D
var translate = null
var velocity = null
var move_player = null
var last_position = null

func _ready():
	pass

func _process(delta: float):
	#print(get_position())
	pass

func _integrate_forces(state):
	var newtransform = state.get_transform()
	print(newtransform)
	print(velocity)
	last_position = newtransform.origin
	print(last_position)
	if translate:
		newtransform.origin = translate
		state.set_transform(newtransform)
		print(translate)
		translate = null
	if velocity:
		state.linear_velocity = velocity
		velocity = null
	if move_player:
		pass

func set_velocity_safely(new_velocity: Vector2):
	velocity = new_velocity

func set_position_safely(coords: Vector2):
	translate = coords

func move_player_to_ball(player: Node, hud: Node):
	player.set_position(get_position())
	player.set_rotation(get_rotation())
	hud.set_position(get_position())
	hud.set_rotation(get_rotation())
