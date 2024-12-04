extends Node
var player
var ball
var phase
var power = 0
var power_held = false
var power_reverse = false
var angle_released = false
var swung = false
var course
var p1_in_play
var p2_in_play
var p3_in_play
var p4_in_play
var num_players
const ROTATION_SPEED = 700
const MAX_POWER = 20

func _ready():
	#course = $Course1
	#call_deferred("change_course", $Course1)
	num_players = get_node("../..").num_players
	player = $P1
	ball = $Ball1
	change_course($Course1)
	change_player($P1, $Ball1)
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
				ball.apply_central_impulse(Vector2(0,-50 * power).rotated(ball.get_rotation()))
				$HitSfx.play()
		elif swung:
			ball.apply_central_force(-ball.linear_velocity.normalized()*50)
			if ball.linear_velocity.length() < 1:
				swung = false
				ball.set_velocity_safely(Vector2(0,0))
				$TurnEndDelay.start()

func angle_phase(delta: float):
	ball.move_player_to_ball(player, $Hud, true)

func power_phase(delta: float):
	if Input.is_anything_pressed():
		power_held = true
		if power >= MAX_POWER:
			power_reverse = true
		elif power <= 0:
			power_reverse = false
		if power_reverse:
			power -= max((10 * (1 + (power/2))) * delta, 0)
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
	p1_in_play = true
	if num_players == 2: p2_in_play = true
	else: p2_in_play = false
	if num_players == 3: p3_in_play = true
	else: p3_in_play = false
	if num_players == 4: p4_in_play = true
	else: p4_in_play = false
	if course:
		course.get_node("HoleHitbox/HoleHitboxShape").set_disabled(true)
		get_tree().call_group(course.name + "Collision", "set_disabled", true)
		course.hide()
	course = new_course
	course.get_node("HoleHitbox/HoleHitboxShape").set_disabled(false)
	get_tree().call_group(course.name + "Collision", "set_disabled", false)
	course.show()
	var spawn = course.get_node("BallSpawn").get_position()
	$Ball1.set_position_safely(spawn)
	$Ball2.set_position_safely(spawn)
	$Ball3.set_position_safely(spawn)
	$Ball4.set_position_safely(spawn)

func reset_course():
	num_players = get_node("../..").num_players
	ball.set_velocity_safely(Vector2(0,0))
	ball.set_position_safely(Vector2(0,0))
	ball.set_angle_safely(0)
	$Ball1.hide()
	$Ball2.hide()
	$Ball3.hide()
	$Ball4.hide()
	get_node("Hud/Angle").hide()
	get_node("Hud/Power").hide()
	get_node("Hud/PowerMeter").hide()
	$P1.hide()
	$P2.hide()
	$P3.hide()
	$P4.hide()
	p1_in_play = true
	if num_players == 2: p2_in_play = true
	else: p2_in_play = false
	if num_players == 3: p3_in_play = true
	else: p3_in_play = false
	if num_players == 4: p4_in_play = true
	else: p4_in_play = false
	var spawn = course.get_node("BallSpawn").get_position()
	$Ball1.set_position_safely(spawn)
	$Ball2.set_position_safely(spawn)
	$Ball3.set_position_safely(spawn)
	$Ball4.set_position_safely(spawn)
	change_player($P1, $Ball1)
	change_phase("Start")
	

func reset():
	reset_course()
	change_course($Course1)

func tapInstant(): # TODO Make a timer at the start of each phase to disable inputs for 1/2 sec
	if phase == "Angle":
		angle_released = false
		change_phase("Power")

func tapRelease():
	pass

func hold():
	pass

func change_player(next_player: Node, next_ball: Node):
	ball.move_player_to_ball(player, $Hud)
	player.hide()
	player = next_player
	ball = next_ball
	ball.show()

func change_phase(next_phase: String):
	phase = next_phase
	match phase:
		"Start":
			ball.move_player_to_ball(player, $Hud, true)
		"Angle":
			get_node("Hud/Angle").show()
			ball.set_constant_torque(ROTATION_SPEED)
			ball.set_angular_velocity_safely(4.24757194519043)
		"Power":
			ball.set_angular_velocity_safely(0)
			ball.set_constant_torque(0)
			player.set_frame(1)
			power = 0
			get_node("Hud/Power").set_region_rect(Rect2(0, 0, power, 3))
			get_node("Hud/Power").show()
			get_node("Hud/PowerMeter").show()
		"Idle":
			swung = false
			player.play()

func ball_sunk(sunk_ball):
	$HoleSfx.play()
	$Confetti.set_position(sunk_ball.get_position())
	$Confetti.play()
	sunk_ball.set_position_safely(Vector2(-1000,-1000))
	sunk_ball.set_velocity_safely(Vector2(10,10))
	match sunk_ball.name:
		"Ball1":
			p1_in_play = false
		"Ball2":
			p2_in_play = false
		"Ball3":
			p3_in_play = false
		"Ball4":
			p4_in_play = false

func _on_turn_end_delay_timeout():
	# Decide how to decide the next player. Order, or furthest?
	player.set_frame(0)
	if !(p1_in_play || p2_in_play || p3_in_play || p4_in_play):
		reset_course()
		match course.name:
			"Course1":
				change_course($Course2)
			"Course2":
				change_course($Course3)
			"Course3":
				reset()
				get_node("../..").change_state(get_node("../../Menu"))
	else:
		var next_player = player
		var next_ball = ball
		match player.name:
			"P1":
				if p2_in_play: 
					next_player = $P2
					next_ball = $Ball2
				elif p3_in_play:
					next_player = $P3
					next_ball = $Ball3
				elif p4_in_play:
					next_player = $P4
					next_ball = $Ball4
			"P2":
				if p3_in_play:
					next_player = $P3
					next_ball = $Ball3
				elif p4_in_play:
					next_player = $P4
					next_ball = $Ball4
				elif p1_in_play:
					next_player = $P1
					next_ball = $Ball1
			"P3":
				if p4_in_play: 
					next_player = $P4
					next_ball = $Ball4
				elif p1_in_play:
					next_player = $P1
					next_ball = $Ball1
				elif p2_in_play:
					next_player = $P2
					next_ball = $Ball2
			"P4":
				if p1_in_play: 
					next_player = $P1
					next_ball = $Ball1
				elif p2_in_play:
					next_player = $P2
					next_ball = $Ball2
				elif p3_in_play:
					next_player = $P3
					next_ball = $Ball3
		change_player(next_player, next_ball)
		change_phase("Start")
