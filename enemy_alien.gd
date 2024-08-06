extends RigidBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 70.0
const GRAVITY = 30.0
const START_HP = 50
var direction = 1
var curr_hp

var _preset = load("res://addons/shaker/data/resources/shake_2d.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("default")
	curr_hp = START_HP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_local_x(delta * SPEED * direction)


func _on_area_2d_body_exited(_body):
	direction *= -1
	animated_sprite.flip_h = !animated_sprite.flip_h
	$Area2D/CollisionShape2D.position.x *= -1

func hit(dmg: float):
	curr_hp -= dmg
	if curr_hp <= 0:
		queue_free()
		
	Shaker.shake_by_preset(_preset, $AnimatedSprite2D, 1.0, 1.0)
	hit_modulate()
	
func hit_modulate():
	animated_sprite.set_modulate(Color(1,0,0))
	$Timer.start()

func _on_timer_timeout():
	animated_sprite.set_modulate(Color(1,1,1))
	
