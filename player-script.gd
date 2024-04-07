extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_mode = true # land mode by default

func mode_check(y_level):
	if y_level >= 0: return false
	else: return true

func _physics_process(delta):
	# Add the gravity.
	if move_mode == true: # land mode
		if not is_on_floor():
			velocity.y += gravity * delta
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	else: # water mode
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
		if Input.is_action_just_pressed("ui_accept"):
			velocity += direction * JUMP_VELOCITY # dash
		if direction:
			velocity = max(velocity.length(), (direction * SPEED / 3).length()) # speed up
		else:
			velocity.x = move_toward(0, 0, SPEED/3) # slow down
	
	move_mode = mode_check(position.y)
	move_and_slide() # push all the changes to its movement
