extends Spatial
class_name Maze

const ROOM_PS: PackedScene = preload("res://Maze/assets/Room.tscn")

var maze_width: int = 15
var maze_height: int = 15

var rooms: Array = [] # Single arrayed approach. [y * array_width + x]

var visited_rooms: Array = []

func _ready():
	randomize()
	
	# Spawn the grid.
	for y in maze_height:
		for x in maze_width:
			var room = ROOM_PS.instance()
			room.translation = Vector3(x, 0, y)
			room.grid_x = x
			room.grid_y = y
			rooms.append(room)
			add_child(room)
			
	# Find the neighbours.
	for room in rooms:
		if room is Room: # Casting
		
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
			
			print(str(room.neighbours.size()))
			
	# Pathfinding.
	# Starting point.
	var start_x: int = 3
	var start_y: int = 3
				
	var current_x: int = start_x
	var current_y: int = start_y
	
	var current_room = rooms[current_y * maze_width + current_x]
	
	# Color and append.
	for i in 26:
		print(i)
		if current_room:
			current_room.ColorRoom(Color.brown)
			visited_rooms.append(current_room)
			current_room = current_room.GetUnvisitedNeighbour() # Can be null.
		else:
			current_room = visited_rooms.pop_back()
			
		
	
	
	

# Test Success.
#	var my_room = rooms[7]
#	my_room.ColorNeighbours(Color.blue)
