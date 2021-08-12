extends KinematicBody

export var speed: float = 3
var velocity: Vector3 = Vector3.ZERO

func _physics_process(delta):
	var direction: Vector3 = Vector3.ZERO

	# Right
	if Input.is_action_pressed("move_right"):
		direction.x += 1

	# Left
	if Input.is_action_pressed("move_left"):
		direction.x += -1

	# Up
	if Input.is_action_pressed("move_up"):
		direction.z += -1

	# Down
	if Input.is_action_pressed("move_down"):
		direction.z += 1

	# HACK: Escape key.
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()

	velocity = direction * speed
	
	
	move_and_slide(velocity)
	print("Velocity: %s" % velocity)
