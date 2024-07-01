extends Node2D

var velocity: Vector2 = Vector2.UP * -1000.0

func _process(delta):
	position += (velocity * delta)
