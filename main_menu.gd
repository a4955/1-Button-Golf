extends CanvasLayer
var selection = 0
var buttons = []
# 0 play, 1 sfx, 2 bgm, 3 exit

func _ready() -> void:
	$Cursor.play("default")
	buttons = [$Play, $Sfx, $Bgm, $Exit]

func _process(delta: float) -> void:
	pass

func change_selection():
	if get_node("../..").sfx: $MoveSfx.play()
	if selection < 3:
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
		0:
			if get_node("../..").sfx: $ConfirmSfx.play()
		1:
			var Main = get_node("../..")
			if Main.sfx:
				Main.sfx = false
				$Sfx.set_frame(1)
			else:
				Main.sfx = true
				$Sfx.set_frame(0)
			if Main.sfx: $ConfirmSfx.play()
		2:
			if get_node("../..").sfx: $ConfirmSfx.play()
			var BgmPlayer = get_node("../../BgmPlayer")
			if BgmPlayer.is_playing():
				BgmPlayer.stop()
				$Bgm.set_frame(1)
			else:
				BgmPlayer.play()
				$Bgm.set_frame(0)
		3:
			get_tree().quit()
