extends Spatial
class_name Maze

const ROOM_PS: PackedScene = preload("res://Maze/assets/Room.tscn")

var maze_width: int = 5
var maze_height: int = 5

var rooms: Array = [] # Single arrayed approach. [y * array_width + x]


func _ready():
	
	# Spawn the grid.
	for y in maze_height:
		for x in maze_width:
			var room: Room = ROOM_PS.instance()
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
			
			print(room.neighbours.size())
	
