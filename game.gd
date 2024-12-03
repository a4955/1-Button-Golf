extends Node
var player
var phase
var power = 0
var power_held = false
var power_reverse = false
var angle_released = false
var swung = false
var course
var p1_coords = Vector2(0,0)
var p2_coords = Vector2(0,0)
var p3_coords = Vector2(0,0)
var p4_coords = Vector2(0,0)
var coords
const ROTATION_SPEED = 3
const MAX_POWER = 20

func _ready():
	change_course($Course1)
	change_player($P1)
	change_phase("Start")

func _process(delta: float):
	match phase:
		"Start":
			change_phase("Angle")
		"Angle":
			angle_phase(delta)
		"Power":
			if angle_released:
				power_phase(delta)
			else:
				if !Input.is_anything_pressed():
					angle_released = true


func _physics_process(delta: float):
	if phase == "Idle": 
		if player.get_frame() == 3:
			if !swung:
				swung = true
				$Ball.apply_central_impulse(Vector2(0,-50 * power).rotated($Ball.get_rotation()))
		elif swung:
			$Ball.apply_central_force(-$Ball.linear_velocity.normalized()*50)
			if $Ball.linear_velocity.abs() < Vector2(1,1):
				swung = false
				$Ball.set_velocity_safely(Vector2(0,0))
				$TurnEndDelay.start()

func angle_phase(delta: float):
	var current_rotation = $Ball.get_rotation()
	$Ball.set_rotation(current_rotation + (ROTATION_SPEED * delta))
	$Hud.set_rotation($Ball.get_rotation())
	player.set_rotation($Ball.get_rotation())

func power_phase(delta: float):
	if Input.is_anything_pressed():
		power_held = true
		if power > MAX_POWER:
			power_reverse = true
		elif power <= 0:
			power_reverse = false
		if power_reverse:
			power -= min((10 * (1 + (power/2))) * delta, 0)
		else:
			power += min((10 * (1 + (power/2))) * delta, MAX_POWER)
		get_node("Hud/Power").set_region_rect(Rect2(0, 0, power, 3))
	else:
		if power_held:
			power_held = false
			get_node("Hud/Angle").hide()
			get_node("Hud/Power").hide()
			get_node("Hud/PowerMeter").hide()
			change_phase("Idle")

func change_course(new_course: Node):
	if course:
		course.get_node("HoleHitbox/HoleHitboxShape").set_disabled(true)
		get_tree().call_group(course.name + "Collision", "set_disabled", true)
		course.hide()
	course = new_course
	course.get_node("HoleHitbox/HoleHitboxShape").set_disabled(false)
	get_tree().call_group(course.name + "Collision", "set_disabled", false)
	course.show()
	p1_coords = course.get_node("BallSpawn").get_position()
	p2_coords = course.get_node("BallSpawn").get_position()
	p3_coords = course.get_node("BallSpawn").get_position()
	p4_coords = course.get_node("BallSpawn").get_position()

func reset():
	pass

func tapInstant(): # TODO Make a timer at the start of each phase to disable inputs for 1/2 sec
	if phase == "Angle":
		angle_released = false
		change_phase("Power")

func tapRelease():
	pass

func hold():
	pass

func change_player(next_player: Node):
	player = next_player
	$P1.hide()
	$P2.hide()
	$P3.hide()
	$P4.hide()
	match next_player.name:
		"P1":
			$Ball.set_position_safely(p1_coords)
			coords = p1_coords
			$P1.show()
		"P2":
			$Ball.set_position_safely(p2_coords)
			coords = p2_coords
			$P2.show()
		"P3":
			$Ball.set_position_safely(p3_coords)
			coords = p3_coords
			$P3.show()
		"P4":
			$Ball.set_position_safely(p4_coords)
			coords = p4_coords
			$P4.show()

func change_phase(next_phase: String):
	phase = next_phase
	match phase:
		"Start":
			player.set_position(coords)
			player.set_rotation($Ball.get_rotation())
			$Hud.set_position(coords)
			$Hud.set_rotation($Ball.get_rotation())
		"Angle":
			get_node("Hud/Angle").show()
		"Power":
			player.set_frame(1)
			power = 0
			get_node("Hud/Power").set_region_rect(Rect2(0, 0, power, 3))
			get_node("Hud/Power").show()
			get_node("Hud/PowerMeter").show()
		"Idle":
			swung = false
			player.play()


func _on_turn_end_delay_timeout():
	# Decide how to decide the next player. Order, or furthest?
	var next_player
	player.set_frame(1)
	match player.name:
		"P1":
			p1_coords = $Ball.get_position()
			if get_node("../..").num_players == 1:
				next_player = $P1
			else:
				next_player = $P2
		"P2":
			p2_coords = $Ball.get_position()
			if get_node("../..").num_players == 2:
				next_player = $P1
			else:
				next_player = $P3
		"P3":
			p3_coords = $Ball.get_position()
			if get_node("../..").num_players == 3:
				next_player = $P1
			else:
				next_player = $P4
		"P4":
			p4_coords = $Ball.get_position()
			next_player = $P1
	change_player(next_player)
	change_phase("Start")
