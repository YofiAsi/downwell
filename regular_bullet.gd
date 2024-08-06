extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision = $Area2D/CollisionShape2D
@export var speed = 800.0
var res: Resource =load("res://regular_weapon.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("fire")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += delta * speed


func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		return
	collision.set_deferred("disabled", true)
	speed = 0.0
	position.y -= 20
	animated_sprite.play("hit")
	if area.has_method("hit"):
		area.hit(res.damage)
	await animated_sprite.animation_finished
	
	queue_free()
