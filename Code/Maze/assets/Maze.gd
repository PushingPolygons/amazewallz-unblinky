extends Spatial
class_name Maze

enum Directions { north, south, east, west } # Obsolete?

const ROOM_PS: PackedScene = preload("res://Maze/assets/Room.tscn")

export var maze_width: int = 10
export var maze_height: int = 10
export var path_length: int = 0

var rooms: Array = [] # Single arrayed approach. [y * array_width + x]

var visited_rooms: Array = []

func _ready():
	randomize()
	SpawnTheGrid()
	FindTheNeighbours()
	CreatePath(1, 1)
	
	
	
	
#	var temp_room: Room = GetRoomAt(1, -5)
#
#	if temp_room:
#		print("Grid X: %s | Grid Y: %s" % [temp_room.grid_x, temp_room.grid_y])
		
		
	
	
func GetDeltaDirection(curent_room: Room, next_room: Room) -> Vector2:
	return Vector2(1, 0)
	
	
func GetRoomAt(grid_x: int, grid_y: int) -> Room:
	if grid_x >= 0 and grid_x < maze_width and grid_y >= 0 and grid_y < maze_height:
		return rooms[grid_y * maze_width + grid_x]
	
	return null
	
	
func SpawnTheGrid() -> void:
	for y in maze_height:
		for x in maze_width:
			var room = ROOM_PS.instance()
			room.translation = Vector3(x, 0, y)
			room.grid_x = x
			room.grid_y = y
			rooms.append(room)
			add_child(room)


func FindTheNeighbours():
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
			
			#print(str(room.neighbours.size()))
			
			
func CreatePath(start_x: int, start_y: int) -> void:
	var current_x: int = start_x
	var current_y: int = start_y
	
	var current_room: Room = rooms[current_y * maze_width + current_x]
	
	# Pathfinding
	for i in path_length:
		#print(i)
		
		if current_room: # Is there valid?
			
			# Where is rando?
			visited_rooms.append(current_room.Visited(Color.brown))
			
			var next_room = current_room.GetRandomNeighbour() # Can be null.
			var direction: int = Directions.north
			

			if next_room:
				var x: int = 0
				var y: int = 0
				var delta_direction: Vector2 = Vector2.ZERO

				#next_room.Visited(Color.forestgreen)
							
				delta_direction = GetDeltaDirection(current_room, next_room) * 2
				current_room = GetRoomAt(current_room.grid_x + delta_direction.x, current_room.grid_y + delta_direction.y)
				
				
#
#				if current_room.grid_x < next_room.grid_x:
#					direction = Directions.west
#
#				if current_room.grid_x > next_room.grid_x:
#					direction = Directions.east
#
#				if current_room.grid_y < next_room.grid_y:
#					direction = Directions.north
#
#				if current_room.grid_y > next_room.grid_y:
#					direction = Directions.south
			else:
				next_room = visited_rooms.pop_back() # Rewind.
				
				# Check for Zero?
				
					
		else:
			current_room = visited_rooms.pop_back() # Rewind.
			

	
#
#func SkipARoom() -> void:
#	# Check X and Y for the delta change to determine direction to skip.
#	var direction = Directions.north
#
#
#	# switch(direction) { } C#
#	match direction:
#		Directions.north:
#			print("north")
#		Directions.south:
#			print("south")
#		Directions.east:
#			print("east")
#		Directions.west:
#			print("west")
#
	

# Test Success.
#	var my_room = rooms[7]
#	my_room.ColorNeighbours(Color.blue)
