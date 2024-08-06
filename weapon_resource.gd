class_name Weapon
extends Resource

@export var scene: PackedScene
@export var name: String
@export var damage: float
@export var fire_rate: float
@export var recoil: float
@export var magazine: int
@export var reload_time: float

var fire_rate_timer: Timer = Timer.new()

func _init():
	pass

func shoot() -> Node:
	return scene.instantiate()
	
