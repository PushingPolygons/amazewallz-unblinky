extends Spatial
class_name Maze

const ROOM_PS: PackedScene = preload("res://Maze/assets/Room.tscn")

export var maze_width: int = 10
export var maze_height: int = 10
export var start_x: int = 1
export var start_y: int = 1

# Colors
export var color_default: Color
export var color_current: Color
export var color_backtrack: Color
export var color_neighbours: Color
export var color_visited: Color

var path_max: int = maze_width * maze_height

var rooms: Array = [] 
var visited_rooms: Array = []
var current_room: Room = null
var next_room: Room = null
var step: int = 0

#------------------------------------------------------------------------------
# Ready()
#------------------------------------------------------------------------------
func _ready():
	randomize()
	SpawnTheGrid()
	FindTheNeighbours()
	ResetMaze()
	
#------------------------------------------------------------------------------
# Process()
#------------------------------------------------------------------------------
func _process(delta_time):
	if Input.is_action_just_pressed("step"):
		StepPath()
		
	if Input.is_action_just_pressed("reset_maze"):
		ResetMaze()

#------------------------------------------------------------------------------
# Reset maze.
#------------------------------------------------------------------------------
func ResetMaze() -> void:
	for room in rooms:
		room.Reset(color_default)
		
	StartPath()
	
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
# Find and store all the adjacent rooms within the grid.
#------------------------------------------------------------------------------
func FindTheNeighbours() -> void:
	for room in rooms:

		# Look left.
		if room.grid_x - 1 >= 0:
			room.AddNeighbour(rooms[room.grid_y * maze_width + room.grid_x - 1])
		
		# Look right.
		if room.grid_x + 1 < maze_width:
			room.AddNeighbour(rooms[room.grid_y * maze_width + room.grid_x + 1])
			
		# Look up.
		if room.grid_y - 1 >= 0:
			room.AddNeighbour(rooms[(room.grid_y - 1) * maze_width + room.grid_x])
			
		# Look down.
		if room.grid_y + 1 < maze_height:
			room.AddNeighbour(rooms[(room.grid_y + 1) * maze_width + room.grid_x])
		
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
#------------------------------------------------------------------------------
func RemoveSelfFromNeighbours():
	for n in current_room.neighbours:
		var i: int = n.neighbours.find(current_room)
#		if i > -1:
#			n.neighbours.remove(i)
#			print(n.neighbours.size())
		print(i)

#------------------------------------------------------------------------------
# Pick the starting point.
# Member function.
#------------------------------------------------------------------------------
func StartPath() -> void:
	current_room = GetRoomAt(start_x, start_y)
	if current_room:
		current_room.ColorNeighbours(color_neighbours)
		current_room.Visited(color_visited)
		visited_rooms.append(current_room)
		RemoveSelfFromNeighbours()
		Report()

#------------------------------------------------------------------------------
# CreatePath() Bores out a random path from the maze grid.
# Pathfinding member function.
#------------------------------------------------------------------------------
func StepPath() -> void:
	current_room.ColorNeighbours(color_default) # Set the neighbours back to default color.
	next_room = current_room.GetRandomNeighbour() # Can be null.

	if step >= 0 and step < path_max:
		if next_room:
			DropWallsBetween(current_room, next_room)
			
			var current_room_index: int = next_room.neighbours.find(current_room)
			var next_room_index: int = current_room.neighbours.find(next_room)
			
			if next_room_index > -1:
				next_room.neighbours.remove(next_room_index)
			
			if current_room_index > -1:
				current_room.neighbours.remove(current_room_index)
				
			visited_rooms.append(next_room)
			current_room = next_room
			
			# Color this step.
			current_room.ColorNeighbours(color_neighbours)
			RemoveSelfFromNeighbours()
			step += 1

		else:
			current_room.Visited(color_visited)
			current_room = visited_rooms.pop_back() # Rewind.
			current_room.ColorSelf(color_backtrack)
			step -= 1
			
	Report()
		
func Report() -> void:
	print("Step: %s" % step)
	print("Current room maze coords: [%s, %s]" % [current_room.grid_x, current_room.grid_y])
	print("Neighbours size: %s" % current_room.neighbours.size())
	print("Visited Rooms: %s" % visited_rooms.size())
	print("---------------------------------")
