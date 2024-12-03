extends RigidBody2D
var translate = null
var velocity = null
var last_position = null
var move_player = null
var player_to_move
var hud_to_move
var angle_change = null
var angle_set = null
var show_player = false
var set_angular_velocity = null

func _ready():
	can_sleep = false
	pass

func _process(delta: float):
	#print(get_position())
	pass

func _integrate_forces(state):
	var new_transform = state.get_transform()
	last_position = new_transform.origin
	if translate != null:
		new_transform.origin = translate
		state.set_transform(new_transform)
		translate = null
	if velocity != null:
		state.linear_velocity = velocity
		velocity = null
	if move_player:
		move_player = false
		player_to_move.set_position(new_transform.origin)
		player_to_move.set_rotation(new_transform.x.angle())
		hud_to_move.set_position(new_transform.origin)
		hud_to_move.set_rotation(new_transform.x.angle())
		if show_player:
			player_to_move.show()
			hud_to_move.show()
	if angle_change != null: # rad
		new_transform.x = new_transform.x.rotated(angle_change)
		angle_change = null
	if angle_set != null:
		new_transform.x = Vector2(0,0).rotated(angle_set)
		angle_set = null
	if set_angular_velocity != null:
		state.angular_velocity = set_angular_velocity
		set_angular_velocity = null
	state.set_transform(new_transform)

func set_angular_velocity_safely(new_angular_velocity: float):
	set_angular_velocity = new_angular_velocity

func change_angle_safely(angle: float): # rad
	angle_change = angle
	
func set_angle_safely(angle: float): # rad
	angle_set = angle
	
func set_velocity_safely(new_velocity: Vector2):
	velocity = new_velocity

func set_position_safely(coords: Vector2):
	translate = coords

func move_player_to_ball(player: Node, hud: Node, show = false):
	show_player = show
	move_player = true
	player_to_move = player
	hud_to_move = hud
