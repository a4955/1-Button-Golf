extends CanvasLayer
signal start_gameplay(num_players)
var current_state

func _ready() -> void:
	current_state = $MainMenu
	$PlayersMenu.hide()

func _process(delta: float) -> void:
	pass

func reset():
	change_state($MainMenu)

func change_state(state):
	if state:
		current_state = state
		match state.name:
			"MainMenu":
				$Title.show()
				$MainMenu.reset()
				$MainMenu.show()
				$PlayersMenu.hide()
			"PlayersMenu":
				$Title.show()
				$PlayersMenu.reset()
				$MainMenu.hide()
				$PlayersMenu.show()
	else:
		$Title.hide()
		$MainMenu.hide()
		$PlayersMenu.hide()

#func resize():
	#if current_state:
		#current_state.resize()

func tapInstant():
	if current_state:
		current_state.tapInstant()

func tapRelease():
	if current_state:
		current_state.tapRelease()

func hold():
	if current_state:
		current_state.hold()

func _on_main_menu_play_pressed():
	change_state($PlayersMenu)

func _on_players_menu_back_to_menu():
	change_state($MainMenu)

func _on_players_menu_start_game(num_players):
	change_state(null)
	start_gameplay.emit(num_players)


func _on_hold_tutorial_frame_changed():
	var frame = $HoldTutorial.frame
	var width = $HoldTutorial/HoldIndRight.position.x - $HoldTutorial/HoldIndLeft.position.x
	match frame:
		2, 3, 4, 5:
			$HoldTutorial/HoldIndLeft.set_size(Vector2((frame - 1) * width / 8,8))
			$HoldTutorial/HoldIndRight.set_size(Vector2((frame - 1) * width / 8,8))
		7:
			$HoldTutorial/HoldIndLeft.set_size(Vector2(0,8))
			$HoldTutorial/HoldIndRight.set_size(Vector2(0,8))
