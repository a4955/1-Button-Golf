extends Area2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D):
	print(body.name)
	get_node("../..").ball_sunk(body)
