extends RigidBody2D
var translate = null
var velocity = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _integrate_forces(state):
	if translate:
		var newtransform = state.get_transform()
		newtransform.origin = translate
		state.set_transform(newtransform)
		translate = null
	if velocity:
		state.linear_velocity = velocity

func set_velocity_safely(new_velocity: Vector2):
	velocity = new_velocity

func set_position_safely(coords: Vector2):
	translate = coords
