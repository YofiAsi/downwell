extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const MAX_FALL_SPEED = -1000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_falling: bool = false
@export var weapon: Weapon = null
@onready var parent = get_parent()
@onready var fire_wait = $FireAfterJump
@onready var coyote_timer = $CoyoteTimer
@onready var ammo_text = $AmmunitionText
@onready var reload_progress_bar = $ProgressBar

var jump_available: bool = true
var was_on_floor: bool = true
var is_reloading: bool = false
var magazine: int = 0

func _ready():
	if weapon != null:
		magazine = weapon.magazine
		ammo_text.frame_coords = Vector2i(magazine % 10, int(magazine / 10))

func _physics_process(delta):		
	if not is_on_floor():
		if was_on_floor:
			was_on_floor = false
			coyote_timer.start()
		
		velocity.y += gravity * delta
		velocity.y = max(velocity.y, MAX_FALL_SPEED)
	else:
		jump_available = true
		was_on_floor = true
		if is_falling:
			is_falling = false
			
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.frame = 0
			$AnimatedSprite2D.stop()
	
	# Handle jump.
	if Input.is_action_pressed("ui_accept"):
		if jump_available:
			jump_available = false
			was_on_floor = false
			velocity.y = JUMP_VELOCITY
			fire_wait.start()
			$AnimatedSprite2D.play("jump")
		if not is_on_floor() and fire_wait.is_stopped():
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

	if is_reloading:
		reload_progress_bar.value = 100 * (weapon.reload_time - $ReloadTimer.time_left) / weapon.reload_time

	move_and_slide()

func reload():
	reload_progress_bar.visible = true
	reload_progress_bar.value = 0
	
	if weapon == null:
		return
	is_reloading = true
	$ReloadTimer.start(weapon.reload_time)

func fire():	
	if magazine > 0:
		if not $FIreRateTimer.is_stopped() or weapon == null:
			return
		
		var new_child = weapon.shoot()
		new_child.position = position + Vector2(0, 16)
		get_parent().add_child(new_child)
		
		recoil()
		magazine -= 1
		ammo_text.frame_coords = Vector2i(magazine % 10, int(magazine / 10))
		$FIreRateTimer.start(weapon.fire_rate)
		
	if magazine <= 0 and not is_reloading:
		reload()	

func recoil():
	if velocity.y < 0:
		velocity.y -= weapon.recoil
	else:
		velocity.y = - weapon.recoil


func _on_coyote_timer_timeout():
	if not is_on_floor():
		jump_available = false


func _on_reload_timer_timeout():
	is_reloading = false
	reload_progress_bar.visible = false
	if weapon != null:
		magazine = weapon.magazine
		ammo_text.frame_coords = Vector2i(magazine % 10, int(magazine / 10))
		
