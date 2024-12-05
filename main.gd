extends Node
var current_state
var hold_ready = false
var hold_cancelled = false
var sfx = true
var hold_enabled = true
var num_players = 1
##### REMEMBER TO TURN MUSIC AUTOPLAY ON
func _ready():
	current_state = $Menu
	$Gameplay.hide()

func _process(delta: float):
	# Polling
	if Input.is_anything_pressed():
		if $HoldTimer.is_stopped() && !hold_cancelled:
			$HoldTimer.start()
	else: 
		hold_cancelled = false
		$HoldTimer.stop()
		if !$TapTimer.is_stopped(): # Tap Input (check for hold)
			$TapTimer.stop()
			tapRelease()
		if hold_ready:
			if hold_enabled:
				hold()
			hold_ready = false
			$HoldTimer.set_paused(false)
			$HoldCancelTimer.stop()
	if hold_enabled:
		var time_left_bar = (1 - ($HoldTimer.time_left / $HoldTimer.wait_time)) * 800
		if $HoldTimer.time_left == 0: time_left_bar = 0
		if hold_ready: time_left_bar = 800
		$HoldIndicator/HoldIndLeft.set_size(Vector2(time_left_bar,40))
		$HoldIndicator/HoldIndRight.set_size(Vector2(time_left_bar,40))
	else: 
		$HoldIndicator/HoldIndLeft.set_size(Vector2(0,40))
		$HoldIndicator/HoldIndRight.set_size(Vector2(0,40))
		

func _input(event: InputEvent):
	# Interrupts 
	if event.is_pressed() && !event.is_echo(): # Tap Input (instant)
		$TapTimer.start()
		tapInstant()

func _on_hold_timer_timeout(): # Hold input
	hold_ready = true
	$HoldTimer.set_paused(true)
	$HoldCancelTimer.start()

func _on_hold_cancel_timer_timeout():
	hold_ready = false
	$HoldTimer.set_paused(false)
	$HoldTimer.stop()
	if hold_enabled:
		hold_cancelled = true
		$CancelSfx.play()

func change_state(state: Node):
	current_state = state
	match state.name:
		"Menu":
			hold_enabled = true
			$Gameplay.hide()
			$Menu.reset()
			$Menu.show()
		"Gameplay":
			hold_enabled = false
			$Menu.hide()
			$Gameplay.reset()
			$Gameplay.show()

func tapInstant():
	current_state.tapInstant()

func tapRelease():
	current_state.tapRelease()

func hold():
	current_state.hold()

func _on_menu_start_gameplay(new_num_players):
	num_players = new_num_players
	change_state($Gameplay)
