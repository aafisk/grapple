#@export var GRAVITY = 250.0
#@export var JUMP_POWER = -250.0
#var airtime = 0
#var airborne = false
#var speed = Vector2(200, 200)
#const FLOOR_DETECT_DISTANCE = 20.0

extends CharacterBody2D

@export var speed = 200
@export var jump_speed = -800
@export var gravity = 4000
@export var grapple_speed = 4000
@export var health = 3
@export var hooked = false
@export var invincibile = false
@export_range(0.0, 1.0) var friction = 0.15
@export_range(0.0 , 1.0) var acceleration = 0.25


var grapple = false

signal hurt

# Size of the game window.
var screen_size 

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	
	if hooked:
		velocity.y = 0
	else:
		velocity.y += gravity * delta

	# Get input based on direction and set x velocity
	var direction = Input.get_axis("left", "right")

	# Determine the direction the player is looking
	if !$rope.fired:
		set_rope_direction()

	# Fire the grappling hook
	if Input.is_action_pressed("grapple") && !$rope.fired:
		$rope.launch_grapple()

	# Only jump when the player is on the ground
	if Input.is_action_just_pressed("jump") and is_on_floor() and !hooked:
		velocity.y = jump_speed

	# Move
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

#	var collision = move_and_collide(Vector2.ZERO)
#
#	var collision_count = 0
#	while (collision and collision_count < 5):
#		var collider = collision.get_collider()
#		print(collider)
	# check_hurt(object)
	
	move_and_slide()

	play_animation()

	# keep the player on screen
	# position = position.clamp(Vector2.ZERO, screen_size)


func set_rope_direction():
	var look_at_point = Vector2(position.x, position.y)
	# Left
	if Input.is_action_pressed("left"):
		look_at_point.y += 10
	# Right
	if Input.is_action_pressed("right"):
		look_at_point.y -= 10
	# Up
	if Input.is_action_pressed("up"):
		look_at_point.x -= 10

	$rope.look_in_direction(look_at_point)

func play_animation():
	# Determine and play animations
	if $rope.fired:
		$AnimatedSprite2D.animation = "grappling"
	elif is_on_floor():
		$AnimatedSprite2D.animation = "walking"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "jumping"
	elif velocity.y > 50:
		$AnimatedSprite2D.animation = "falling"

	# Flip sprite based on direction
	if abs(velocity.x) == 0:
		$AnimatedSprite2D.stop()
	else:
		$AnimatedSprite2D.flip_h = velocity.x < 0

	# Play the animation
	$AnimatedSprite2D.play()
	

func _on_rope_hooked(hooked_position):
	hooked = true
	await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", hooked_position, 0.75)
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.75).timeout
	hooked = false

func check_hurt(body):
	if body.get_collision_layer() == 3:
		health -= 1
		emit_signal("hurt")
		if health <= 0:
			hide()
		await get_tree().create_timer(5).timeout

#func check_lr_input(velocity):
#	if Input.is_action_pressed("walkLeft"):
#		velocity.x -= 1
#	if Input.is_action_pressed("walkRight"):
#		velocity.x += 1
#
#	return velocity.x

#func _physics_process(delta):
#	velocity = Vector2.ZERO
#
#	velocity.x = check_lr_input(velocity)
#
#	position.x += velocity.x * delta * speed
#	position = position.clamp(Vector2.ZERO, screen_size)
#
#	if abs(velocity.x) > 0:
#		$AnimatedSprite2D.play()
#		$AnimatedSprite2D.animation = "walking"
#		$AnimatedSprite2D.flip_h = velocity.x < 0
#	else:
#		$AnimatedSprite2D.stop()
#
#	if !airborne && Input.is_action_pressed("jump"):
#		#if velocity.y >= 0:
#		#	 velocity.y = 0
#		velocity.y = JUMP_POWER
#	else:
#		velocity.y += GRAVITY
#
##	if
##		airborne = false
##	else:
##		airborne = true
#
#	#move_and_collide(velocity * delta)
#	move_and_slide()

#func get_direction():
#	return Vector2(
#		Input.get_action_strength("walkRight") - Input.get_action_strength("walkLeft"),
#		-15 if is_on_floor() and Input.is_action_just_pressed("jump") else 2
#	)
#
#func calculate_move_velocity(linear_velocity, direction, is_jump_interrupted):
#	var velocity = linear_velocity
#	velocity.x = speed.x * direction.x
#	if direction.y != 0.0:
#		velocity.y = speed.y * direction.y
#	if is_jump_interrupted:
#		# Decrease the Y velocity by multiplying it, but don't set it to 0
#		# as to not be too abrupt.
#		velocity.y *= 0.6
#	return velocity
#
##demo player code
#func _physics_process(_delta):
#	# Play jump sound
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		#sound_jump.play()
#		pass
#
#	var direction = get_direction()
#
#	var is_jump_interrupted = Input.is_action_just_released("jump") and velocity.y < 0.0
#	velocity = calculate_move_velocity(velocity, direction, is_jump_interrupted)
#
#	var snap_vector = Vector2.ZERO
#	if direction.y == 0.0:
#		floor_snap_length = FLOOR_DETECT_DISTANCE
#	var is_on_platform = platform_detector.is_colliding()
#
#	move_and_slide()
#
#	# flip the sprite accordingly and play the animation
#	if abs(velocity.x) > 0:
#		$AnimatedSprite2D.play()
#		$AnimatedSprite2D.animation = "walking"
#		$AnimatedSprite2D.flip_h = velocity.x < 0
#	else:
#		$AnimatedSprite2D.stop()




