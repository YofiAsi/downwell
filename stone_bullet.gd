extends Node2D

const SPEED: float = 700.0

var direction: Vector2 = Vector2.DOWN

func _init():
	#$Sprite2D.rotation = randf_range(0, 2 * PI)
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += SPEED * direction * delta
