extends Node2D

@export var stone_bullet = load("res://stone_bullet.tscn")
@export var num_of_bullets: int = 5
@export var spread_fan: float = PI / 8
var angle_between_bullets: float = spread_fan / (num_of_bullets - 1)
var first_bullet_angle: float = PI + (spread_fan / 2)

func _init():
	var bullets = Array()
	for i in range(num_of_bullets):
		var new_bullet = stone_bullet.instantiate()
		new_bullet.direction = Vector2.UP.rotated(first_bullet_angle - i * angle_between_bullets)
		bullets.append(new_bullet)
	
	for i in range(num_of_bullets):
		add_child(bullets[i])

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
