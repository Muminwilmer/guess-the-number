extends CharacterBody2D

# Movement speed and gravity
@export var speed: float = 200.0
@export var gravity: float = 800.0
@export var jump_force: float = -320.0

var is_dashing = false

var dash_speed = 600.0
var dash_length = 0.4
var dash_remain = 0.0

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	# Horizontal movement
	var input_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.x = input_direction * speed

	# Jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	handle_dashing(delta)
	move_and_slide()


func handle_dashing(delta):
	if Input.is_action_just_pressed("dash") and $DashDelay.is_stopped() and not dash_remain > dash_length:
		is_dashing = true
		
		# Determine dash direction
		var direction_x = Input.get_axis("left", "right")
		
		if is_on_floor():
			# Ground dash in the direction the player is moving or facing
			if direction_x == 0:
				is_dashing = false
				pass
				#direction_x = sign(velocity.x)  # Maintain facing direction if no input
			velocity.x = direction_x * dash_speed
			velocity.y = 0  # No vertical movement on ground dash
		else:
			# Air dash upwards but maintain horizontal movement
			if direction_x == 0:
				direction_x = sign(velocity.x)  # Keep existing horizontal direction if moving
			velocity.x = direction_x * dash_speed  # Keep moving in the same direction
			velocity.y = -dash_speed * 0.5  # Upward boost (adjust multiplier for feel)
		
		
	if is_dashing:
		dash_remain += delta
		create_dash_trail()

	if is_dashing and dash_remain > dash_length:
		is_dashing = false

	if dash_remain > dash_length and is_on_floor():
		dash_remain = 0.0
		$DashDelay.start()
	
func create_dash_trail():
	var ghost = Sprite2D.new()
	ghost.texture = $Sprite2D.texture
	ghost.hframes = $Sprite2D.hframes
	ghost.vframes = $Sprite2D.vframes
	ghost.frame = 0
	ghost.scale = $Sprite2D.scale
	ghost.global_position = $Sprite2D.global_position
	ghost.modulate = Color(1, 1, 1, 0.2)  # White with transparency
	add_sibling(ghost)

	var tween = get_tree().create_tween() # Does magic idk how this works
	tween.tween_property(ghost, "modulate", Color(1, 1, 1, 0), 0.5)  # Fade
	tween.tween_callback(ghost.queue_free)  # Delete after fade

	# Move the character

	
	
