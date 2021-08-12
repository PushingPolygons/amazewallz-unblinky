extends KinematicBody

var speed: float = 3 # Meters / sec
var velocity: Vector3 = Vector3(1, 0, 0)

func _physics_process(delta):
	move_and_slide(velocity)
	print("Velocity: %s" % velocity)
#
#	var direction: Vector3 = Vector3.ZERO
#
#	# Right
#	if Input.is_action_pressed("move_right"):
#		direction.x += 1
#
#	# Left
#	if Input.is_action_pressed("move_left"):
#		direction.x += -1
#
#	# Up
#	if Input.is_action_pressed("move_up"):
#		direction.z += -1
#
#	# Down
#	if Input.is_action_pressed("move_down"):
#		direction.z += 1
#
#	# HACK: Escape key.
#	if Input.is_action_just_pressed("quit_game"):
#		get_tree().quit()
#
#	# Set the velocity based on player input.
#	#velocity = speed * direction * delta_time
#	velocity = move_and_slide(velocity, Vector3.UP)
##
#	self.translate(velocity)

#
#func _unhandled_key_input(event):
#	if event is InputEventKey:
#		if event.
