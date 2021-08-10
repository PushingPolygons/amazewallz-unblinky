extends Spatial
class_name Maze

const ROOM_PS: PackedScene = preload("res://Maze/assets/Room.tscn")

export var maze_width: int = 10
export var maze_height: int = 10

# Floor colors.
export var default_color: Color
export var current_color: Color
export var seek_color: Color
export var visited_color: Color



var rooms: Array = [] # Single arrayed approach. [y * array_width + x]


# Path variables.
var current_room: Room = null
var visited_rooms: Array = []
var path_step: int = 0
var path_max: int = 0

#------------------------------------------------------------------------------
# Ready()
#------------------------------------------------------------------------------
func _ready():
	randomize()
	SpawnTheGrid() # Fills up rooms[].
	Initialize()

	
#------------------------------------------------------------------------------
# Process()
#------------------------------------------------------------------------------
func _process(_delta):
	if Input.is_action_just_pressed("step_path"):
		StepPath()
		
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func Initialize() -> void:
	
	path_max = maze_width * maze_height

	for room in rooms:
		room.ColorFloor(default_color)
		
	visited_rooms.clear()
	path_step = 0
	
	# TODO: Random.
	StartPath(0, 2)
	
	
			
#------------------------------------------------------------------------------
# StartPath()
#------------------------------------------------------------------------------
func StartPath(start_x: int, start_y: int) -> void:
	current_room = rooms[start_y * maze_width + start_x]
	
	if current_room:
		current_room.Visit(current_color)
		var neighbours: Array = FindTheNeighbours(current_room)
		for neighbour in neighbours:
			neighbour.ColorFloor(seek_color)
			
		print("---------------- Step (%s)" % path_step)
		print("Grid coords: [%s, %s]" % [current_room.grid_x, current_room.grid_y])
		print("Neighbour count: %s" % neighbours.size())


#------------------------------------------------------------------------------
# StepPath()
# LMB click?
#------------------------------------------------------------------------------
func StepPath():
	path_step += 1
	print("---------------- Step (%s)" % path_step)
	print("Grid coords: [%s, %s]" % [current_room.grid_x, current_room.grid_y])
	
	# Erase current neighbours grapics.
	var neighbours: Array = FindTheNeighbours(current_room)
	for n in neighbours:
		n.ColorFloor(default_color)
	
	# Get the next random room.
	var rando: int = randi() % neighbours.size()
	current_room = neighbours[rando] # Increment.
	current_room.Visit(current_color)
	
	neighbours = FindTheNeighbours(current_room)
	
	for n in neighbours:
		n.ColorFloor(seek_color)
	
	print("Neighbour count: %s" % neighbours.size())



#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func DropWalls(room_a, room_b) -> void:
	if room_a.grid_x < room_b.grid_x:
		room_a.DropWall(Directions.right)
		room_b.DropWall(Directions.right)
		

	
#------------------------------------------------------------------------------
# Get Room at the specified grid coords. Can retun null.
#------------------------------------------------------------------------------
func GetRoomAt(grid_x: int, grid_y: int):
	if grid_x >= 0 and grid_x < maze_width and grid_y >= 0 and grid_y < maze_height:
		return rooms[grid_y * maze_width + grid_x]
	
	return null
	
#------------------------------------------------------------------------------
# 
#------------------------------------------------------------------------------
func SpawnTheGrid() -> void:
	for y in maze_height:
		for x in maze_width:
			var room = ROOM_PS.instance()
			room.translation = Vector3(x * 2.2, 0, y * 2.2)
			room.grid_x = x
			room.grid_y = y
			rooms.append(room)
			add_child(room)

#------------------------------------------------------------------------------
# Search for the neighbours and return references to any found.
# Can return with no size() 0.
#------------------------------------------------------------------------------
func FindTheNeighbours(room: Room) -> Array:
	
	var neighbours: Array = []
	
	# Look left.
	if room.grid_x - 1 >= 0:
		var seek_room: Room = rooms[room.grid_y * maze_width + room.grid_x - 1]
		if !seek_room.visited:
			neighbours.append(seek_room)
	
	# Look right.
	if room.grid_x + 1 < maze_width:
		var seek_room: Room = rooms[room.grid_y * maze_width + room.grid_x + 1]
		if !seek_room.visited:
			neighbours.append(seek_room)
				
	# Look up.
	if room.grid_y - 1 >= 0:
		var seek_room: Room = rooms[(room.grid_y - 1) * maze_width + room.grid_x]
		if !seek_room.visited:
			neighbours.append(seek_room)
		
	# Look down.
	if room.grid_y + 1 < maze_height:
		var seek_room: Room = rooms[(room.grid_y + 1) * maze_width + room.grid_x]
		if !seek_room.visited:
			neighbours.append(seek_room)
		
	return neighbours



func GetRandomNeighbour() -> Room:
	var neighbours: Array = FindTheNeighbours(current_room)
	
	if neighbours.size() > 0:
		var rando = randi() % neighbours.size()
		var room: Room = neighbours[rando]
		return room

	return null



#
#		# Where is rando?
#		visited_rooms.append(current_room.Visited(Color.brown))
#
		# If we are on 0 or width -1 pop back
	
	
#
#
#		var next_room = current_room.GetRandomNeighbour() # Can be null.
#
#		# Checking for null.
#		if next_room:
#
#			if next_room.grid_x >= 0 and next_room.grid_x < maze_width and next_room.grid_y >= 0 and next_room.grid_y < maze_width:
#
#				var x: int = 0
#				var y: int = 0
#				var delta_direction: Vector2 = Vector2.ZERO
#
#				next_room.Visited(Color.forestgreen)
#
#				delta_direction = GetDeltaDirection(current_room, next_room)
#
#				delta_direction = delta_direction * 2
#				current_room = GetRoomAt(current_room.grid_x + delta_direction.x, current_room.grid_y + delta_direction.y)
#
#				if !current_room:
#					break
#
#		else:
#			next_room = visited_rooms.pop_back() # Rewind.
#
#			# Check for Zero?
#
#	else:
#		current_room = visited_rooms.pop_back() # Rewind.
#
