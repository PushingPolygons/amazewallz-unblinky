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
var visited_rooms: Array = [] # Rewinding
var visited_count: int = 0
var step_count: int = 0 # 
var path_max: int = 0

#------------------------------------------------------------------------------
# Ready()
#------------------------------------------------------------------------------
func _ready():
	randomize()
	path_max = maze_width * maze_height
	SpawnTheGrid() # Fills up rooms[].
	for room in rooms:
		room.ColorFloor(default_color)
	
	# Path stuff.
	var grid_x: int = randi() % maze_width
	var grid_y: int = randi() % maze_height
	StartPath(grid_x, grid_y)
	#Initialize()

	
#------------------------------------------------------------------------------
# Process()
#------------------------------------------------------------------------------
func _process(_delta):
	if Input.is_action_just_pressed("step_path"):
		StepPath()
		

		
#
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
#func Initialize() -> void:
#
#	path_max = maze_width * maze_height
#
#	for room in rooms:
#		room.ColorFloor(default_color)
#
#	visited_rooms.clear()
#	path_step = 0
#
#	# TODO: Random.
#	var grid_x: int = randi() % maze_width
#	var grid_y: int = randi() % maze_height
#	StartPath(grid_x, grid_y)
	
	
			
#------------------------------------------------------------------------------
# StartPath()
#------------------------------------------------------------------------------
func StartPath(start_x: int, start_y: int) -> void:
	current_room = rooms[start_y * maze_width + start_x]
	
	if current_room:
		current_room.Visit(current_color)
		visited_rooms.append(current_room)
		visited_count += 1
		
		var neighbours: Array = FindTheNeighbours(current_room)
		for neighbour in neighbours:
			neighbour.ColorFloor(seek_color)
			
		print("---------------- Step (%s)" % step_count)
		print("Grid coords: [%s, %s]" % [current_room.grid_x, current_room.grid_y])
		print("Neighbour count: %s" % neighbours.size())


#------------------------------------------------------------------------------
# StepPath()
# LMB click?
#------------------------------------------------------------------------------
func StepPath():
	if visited_count < path_max:
		step_count += 1
		print("---------------- Step (%s)" % step_count)
		print("Grid coords: [%s, %s]" % [current_room.grid_x, current_room.grid_y])
		
		var neighbours: Array = FindTheNeighbours(current_room)
		if neighbours.size() > 0:
			
			# Erase current neighbours grapics.
			for n in neighbours:
				n.ColorFloor(default_color)
		
			# Get the next random room.
			var rando: int = randi() % neighbours.size()
			var next_room: Room = neighbours[rando] # Increment.
			DropWalls(current_room, next_room)
			current_room.ColorFloor(visited_color)
			current_room = next_room
			current_room.Visit(current_color)
			visited_rooms.append(current_room)
			visited_count += 1
			
			# Color the neighbours.
			neighbours = FindTheNeighbours(current_room)
			for n in neighbours:
				n.ColorFloor(seek_color)
			
			print("Neighbour count: %s" % neighbours.size())
			
		# Dead end.
		else:
			current_room.ColorFloor(visited_color)
			current_room = visited_rooms.pop_back()
			current_room.ColorFloor(current_color)
			
			# HACK: Code dup!
			neighbours = FindTheNeighbours(current_room)
			for n in neighbours:
				n.ColorFloor(seek_color)
	else:
		print("Maze is complete.")
		#Main.ResetMaze()

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func DropWalls(room_a, room_b) -> void:
	
	# Left
	if room_a.grid_x < room_b.grid_x:
		room_a.DropWall(Directions.RIGHT)
		room_b.DropWall(Directions.LEFT)
	
	# Right	
	if room_a.grid_x > room_b.grid_x:
		room_a.DropWall(Directions.LEFT)
		room_b.DropWall(Directions.RIGHT)
	
	# Up
	if room_a.grid_y < room_b.grid_y:
		room_a.DropWall(Directions.DOWN)
		room_b.DropWall(Directions.UP)
	
	# Down
	if room_a.grid_y > room_b.grid_y:
		room_a.DropWall(Directions.UP)
		room_b.DropWall(Directions.DOWN)
	
		
	
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


func _on_Timer_timeout():
	StepPath()
	pass # Replace with function body.
