extends Spatial
class_name Maze

const ROOM_PS: PackedScene = preload("res://Maze/assets/Room.tscn")

export var maze_width: int = 10
export var maze_height: int = 10
export var path_length: int = 0

var rooms: Array = [] 
var visited_rooms: Array = []

#------------------------------------------------------------------------------
# Ready()
#------------------------------------------------------------------------------
func _ready():
	randomize()
	SpawnTheGrid()
	FindTheNeighbours()
	CreatePath(5, 5)
	
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
			
			#print(str(room.neighbours.size()))

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
# CreatePath()
#------------------------------------------------------------------------------
func CreatePath(start_x: int, start_y: int) -> void:
	
	var current_room: Room = GetRoomAt(start_x, start_y)
	
#	var room_a: Room = GetRoomAt(4, 3)
#	var room_b: Room = GetRoomAt(3, 3)
	
#	var room_a: Room = rooms[2 * maze_width + 0]
#	var room_b: Room = rooms[3 * maze_width + 0]
	
#	room_a.Visited(Color.red)
#	room_b.Visited(Color.yellow)

#	DropWallsBetween(room_a, room_b)


	# Pathfinding.
	for i in path_length:
		# TODO: Make a timer later that can delay the path as it blocks out each room.
		
		print(i)

		if current_room: # Is it valid?

			current_room.Visited(Color.brown)
			visited_rooms.append(current_room)

			var next_room: Room = current_room.GetRandomNeighbour() # Can be null.

			# Checking for null.
			if next_room:
				DropWallsBetween(current_room, next_room)

			else:
				next_room = visited_rooms.pop_back() # Rewind.

#				# Check for Zero?
#
#		else:
#			current_room = visited_rooms.pop_back() # Rewind.
	print("Visited Rooms: %s" % visited_rooms.size())
