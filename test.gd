extends Node2D

@onready var camera = $Camera2D
@onready var player = $player
var last_wall_pos
var wall_scene = preload('res://walls.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	last_wall_pos = Vector2(216, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position.y = max(player.position.y-200, 0)
	


func _on_walls_make_new_walls():
	var new_walls: Node2D = wall_scene.instantiate()
	new_walls.position = last_wall_pos
	new_walls.position.y += 544
	last_wall_pos = new_walls.position
	new_walls.make_new_walls.connect(_on_walls_make_new_walls)
	add_child(new_walls)
