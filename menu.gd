extends CanvasLayer
signal start_gameplay
var current_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state = $MainMenu
	$PlayersMenu.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset():
	change_state($MainMenu)

func change_state(state):
	if state:
		current_state = state
		match state.name:
			"MainMenu":
				$MainMenu.reset()
				$MainMenu.show()
				$PlayersMenu.hide()
			"PlayersMenu":
				$PlayersMenu.reset()
				$MainMenu.hide()
				$PlayersMenu.show()
	else:
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
	num_players = 4 ##### HARDCODE, REMOVE THIS AFTER TESTING
	change_state(null)
	start_gameplay.emit(num_players)
