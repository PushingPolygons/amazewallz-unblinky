extends Spatial
class_name Maze

const ROOM_PS: PackedScene = preload("res://Maze/assets/Room.tscn")

export var maze_width: int = 5
export var maze_height: int = 5

# Colors
export var color_default: Color
export var color_current: Color
export var color_neighbours: Color
export var color_backtrack: Color
export var color_visited: Color

# Path variables.
var path_max: int

var rooms: Array = []
var neighbours_count: int = 0
var breadcrumbs: Array = []
var visited_count: int = 0
var current_room: Room = null
var next_room: Room = null
var step: int = 0

#------------------------------------------------------------------------------
# Ready()
#------------------------------------------------------------------------------
func _ready():
	
	# Random starting point.
	randomize()
	SpawnTheGrid()
	Initialize()
	print("Path max: %s" % path_max)
	
#------------------------------------------------------------------------------
# Process()
#------------------------------------------------------------------------------
func _process(delta_time):
	if Input.is_action_just_pressed("step"):
		StepPath()
		
	if Input.is_action_just_pressed("reset_maze"):
		Initialize()

#------------------------------------------------------------------------------
# Reset maze.
#------------------------------------------------------------------------------
func Initialize() -> void:
	
	path_max = maze_width * maze_height
	visited_count = 0
	breadcrumbs.clear()
	current_room = null
	next_room = null
	step = 0
	neighbours_count = 0
	
	# Reset rooms' color and walls.
	for room in rooms:
		room.Reset(color_default)
	
	# Get a random point in the maze to start.
	var random_x: int = randi() % maze_width
	var random_y: int = randi() % maze_height
	StartPath(random_x, random_y)
	
	while visited_count < path_max:
		StepPath()
	
	
	#for i in path_max:
	#	StepPath()
	
#------------------------------------------------------------------------------
# GetRoomAt(x, y) in grid coords. Single array approach.
# Use: var room = rooms[y * array_width + x]
#------------------------------------------------------------------------------
func GetRoomAt(grid_x: int, grid_y: int) -> Room:
	if grid_x >= 0 and grid_x < maze_width and grid_y >= 0 and grid_y < maze_height:
		return rooms[grid_y * maze_width + grid_x]
	return null
	
#------------------------------------------------------------------------------
# Spawn the grid of rooms
#------------------------------------------------------------------------------
func SpawnTheGrid() -> void:
	for y in maze_height:
		for x in maze_width:
			var room = ROOM_PS.instance()
			room.translation = Vector3(x * 2.5, 0, y * 2.5)
			room.grid_x = x
			room.grid_y = y
			rooms.append(room)
			add_child(room)
	
#------------------------------------------------------------------------------
# Returns an array of neighbours. Check for size().
#------------------------------------------------------------------------------
func FindNeighbours(room: Room) -> Array:
	
	#------------------------------------
	# Find and fill the neighbours array.
	#------------------------------------
	var neighbours: Array = []

	# Look left.
	if room.grid_x - 1 >= 0:
		var look: Room = rooms[room.grid_y * maze_width + room.grid_x - 1]
		if !look.visited:
			neighbours.append(look)
			
	# Look right.
	if room.grid_x + 1 < maze_width:
		var look: Room = rooms[room.grid_y * maze_width + room.grid_x + 1]
		if !look.visited:
			neighbours.append(look)

	# Look up.
	if room.grid_y - 1 >= 0:
		var look: Room = rooms[(room.grid_y - 1) * maze_width + room.grid_x]
		if !look.visited:
			neighbours.append(look)
		
	# Look down.
	if room.grid_y + 1 < maze_height:
		var look: Room = rooms[(room.grid_y + 1) * maze_width + room.grid_x]
		if !look.visited:
			neighbours.append(look)

	return neighbours

#------------------------------------------------------------------------------
# Find and color.
#------------------------------------------------------------------------------
func FindAndColorNeighbours(color: Color) -> Array:
	var neighbours: Array = FindNeighbours(current_room)
	for neighbour in neighbours:
		neighbour.ColorFloor(color)
	return neighbours
	
#------------------------------------------------------------------------------
# Drop the Walls between 2 rooms.
#------------------------------------------------------------------------------
func DropWallsBetween(room_a, room_b) -> void:
	
	# Drop right.
	if room_a.grid_x < room_b.grid_x:
		room_a.DropWall(Directions.RIGHT)
		room_b.DropWall(Directions.LEFT)
		
	# Drop left.
	if room_a.grid_x > room_b.grid_x:
		room_a.DropWall(Directions.LEFT)
		room_b.DropWall(Directions.RIGHT)
		
	# Drop down.		
	if room_a.grid_y < room_b.grid_y:
		room_a.DropWall(Directions.DOWN)
		room_b.DropWall(Directions.UP)
		
	# Drop up.
	if room_a.grid_y > room_b.grid_y:
		room_a.DropWall(Directions.UP)
		room_b.DropWall(Directions.DOWN)

#------------------------------------------------------------------------------
# Pick the specified starting point.
# Member function.
#------------------------------------------------------------------------------
func StartPath(grid_x: int, grid_y: int) -> void:
	current_room = GetRoomAt(grid_x, grid_y)
	
	if current_room:
		breadcrumbs.append(current_room)
		current_room.ColorFloor(color_current)
		FindAndColorNeighbours(color_neighbours)
		
		# ++
		current_room.Visit()
		visited_count += 1
		
		# Slight duplication.
#		print("-------------Step-------------(%s)" % step)
#		print("Current room maze coords: [%s, %s]" % [current_room.grid_x, current_room.grid_y])
#		print("Neighbour count: %s" % FindNeighbours(current_room).size())#neighbours.size())
#		print("Breadcrumbs: %s" % breadcrumbs.size())
#		print("---------------------------------")

#------------------------------------------------------------------------------
# CreatePath() Bores out a random path from the maze grid.
# Pathfinding member function.
#------------------------------------------------------------------------------
func StepPath() -> void:
	step += 1
	print("-------------Step-------------(%s)" % step)
	var neighbours: Array = FindAndColorNeighbours(color_default) # "Uncolor" the looks.
	
	# Grab a random neighbour.
	if visited_count < path_max:
		if neighbours.size() > 0:
				
			var rando: int = randi() % neighbours.size()
			next_room = neighbours[rando]

			if next_room:
				current_room.ColorFloor(color_visited) # "Uncolor" the position.
				DropWallsBetween(current_room, next_room)
				
				# ++ next_room.
				current_room = next_room
				breadcrumbs.append(current_room)
				current_room.Visit()
				visited_count += 1
				
				# Graphics.
				current_room.ColorFloor(color_current)
				FindAndColorNeighbours(color_neighbours)

		else:
			print("No neighbours left.")
			current_room.ColorFloor(color_visited)
			current_room = breadcrumbs.pop_back() # Rewind a step.
			current_room.ColorFloor(color_backtrack)
	
	else:
		print("Maze complete.")
		#Initialize() #Loop
		

#	print("Current room maze coords: [%s, %s]" % [current_room.grid_x, current_room.grid_y])
#	print("Neighbour count: %s" % FindNeighbours(current_room).size())#neighbours.size())
#	print("Breadcrumbs: %s" % breadcrumbs.size())
#	print("---------------------------------")

func _on_Timer_timeout():
	StepPath()
	pass # Replace with function body.
