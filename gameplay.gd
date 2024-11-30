extends Node
var current_state
# If time, add an intro state

func _ready() -> void:
	current_state = $Tutorial

func _process(delta: float):
	pass

func show():
	pass

func hide():
	pass

func reset():
	pass

func tapInstant():
	pass

func tapRelease():
	pass

func hold():
	pass
	
func change_state(state: Node):
	current_state = state
	match state.name:
		"Intro":
			pass
		"Tutorial":
			pass
		"Game":
			pass
		"Results":
			pass

func _on_hold_tutorial_frame_changed():
	var frame = $Tutorial/HoldTutorial.frame
	var width = $Tutorial/HoldTutorial/HoldIndRight.position.x - $Tutorial/HoldTutorial/HoldIndLeft.position.x
	match frame:
		2, 3, 4, 5:
			$Tutorial/HoldTutorial/HoldIndLeft.set_size(Vector2((frame - 1) * width / 8,8))
			$Tutorial/HoldTutorial/HoldIndRight.set_size(Vector2((frame - 1) * width / 8,8))
		7:
			$Tutorial/HoldTutorial/HoldIndLeft.set_size(Vector2(0,8))
			$Tutorial/HoldTutorial/HoldIndRight.set_size(Vector2(0,8))
