extends CanvasLayer
signal start_game
signal back_to_menu

func _ready() -> void:
	$Cursor.play("default")
	buttons = [$"1p", $"2p", $"3p", $"4p", $Back]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var selection = 0
var buttons = []
# 0 play, 1 sfx, 2 bgm, 3 exit

func reset():
	selection = 0
	$Cursor.position.x = buttons[selection].position.x

func change_selection():
	if get_node("../..").sfx: get_node("../MoveSfx").play()
	if selection < len(buttons) - 1:
		selection += 1
	else:
		selection = 0
	$Cursor.position.x = buttons[selection].position.x

#const ICON_OFFSET = 0.2
#const ICON_DISTANCE = (1 - (ICON_OFFSET * 2)) / 3
#THIS WAS POINTLESS
#func resize():
	#$Play.position.x = ICON_OFFSET * get_viewport().size.x
	#$Sfx.position.x = (ICON_OFFSET + ICON_DISTANCE) * get_viewport().size.x
	#$Bgm.position.x = (ICON_OFFSET + ICON_DISTANCE * 2) * get_viewport().size.x
	#$Exit.position.x = (ICON_OFFSET + ICON_DISTANCE * 3) * get_viewport().size.x
	#$Cursor.position.x = buttons[selection].position.x
	#pass

func tapInstant():
	pass

func tapRelease():
	change_selection()

func hold():
	# 0 play, 1 sfx, 2 bgm, 3 exit
	match selection:
		0, 1, 2, 3:
			if get_node("../..").sfx: get_node("../ConfirmSfx").play()
			start_game.emit(selection + 1) # num players is selection + 1
		4:
			if get_node("../..").sfx: get_node("../ConfirmSfx").play()
			back_to_menu.emit()
