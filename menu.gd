extends CanvasLayer

var current_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state = $MainMenu
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset():
	change_state($MainMenu)

func change_state(state: Node):
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
		_:
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
