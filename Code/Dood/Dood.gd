extends KinematicBody


var speed: float = 1
var velocity: Vector3 = Vector3(1, 0, 0)


func _physics_process(delta):
	if Input.is_action_just_pressed("move_right"):
		print("Move Right")
		self.translate(velocity) 



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
