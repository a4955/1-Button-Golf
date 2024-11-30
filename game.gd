extends Node
var player
var phase

func _ready() -> void:
	player = $P1

func _process(delta: float) -> void:
	pass
	
func change_player(next_player: Node):
	player = next_player
	match next_player.name:
		"P1":
			pass
		"P2":
			pass
		"P3":
			pass
		"P4":
			pass

func change_phase(next_phase: Node):
	phase = next_phase
	match next_phase.name:
		"Start":
			pass
		"Angle":
			pass
		"Power":
			pass
		"Idle":
			pass
