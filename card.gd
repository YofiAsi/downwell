extends Node2D

var wepon_info: Weapon
var velocity: Vector2 = Vector2.ZERO

func _process(delta):
	position += (velocity * delta)
