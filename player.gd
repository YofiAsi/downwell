extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_falling: bool = false

@onready var parent = get_parent()

@export var weapon: PackedScene

func _physics_process(delta):	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	elif is_falling:
		is_falling = false
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.frame = 5
		$AnimatedSprite2D.stop()
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.play("jump")
		else:
			fire()
	
	if velocity.y > 0:
		is_falling = true
		$AnimatedSprite2D.play("fall")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# flip sprite if needed
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		if not $AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	move_and_slide()


func fire():
	print("fire")
	if not $Timer.is_stopped():
		return
	
	if velocity.y < 0:
		velocity.y += -150.0
	else:
		velocity.y = -150.0
	$Timer.start()
	
	var n = weapon.instantiate()
	n.velocity.y = 1000.0
	n.position = position
	
	parent.add_child(n)
