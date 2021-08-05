extends Spatial
class_name Maze



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
	CreatePath(5, 5)
	

func DropWalls(room_a, room_b) -> void:
	if room_a.grid_x < room_b.grid_x:
		room_a.DropWall(Directions.right)
		room_b.DropWall(Directions.right)
		

	
	
#	var temp_room: Room = GetRoomAt(1, -5)
#
#	if temp_room:
#		print("Grid X: %s | Grid Y: %s" % [temp_room.grid_x, temp_room.grid_y])
		
		
#------------------------------------------------------------------------------
# DeltaDirection()
#------------------------------------------------------------------------------
func GetDeltaDirection(current_room, next_room) -> Vector2:

	if current_room.grid_x < next_room.grid_x:
		return Vector2(1, 0)
	if current_room.grid_x > next_room.grid_x:
		return Vector2(-1, 0)
	if current_room.grid_y < next_room.grid_y:
		return Vector2(0, 1)
	if current_room.grid_y > next_room.grid_y:
		return Vector2(0, -1)
	
	return Vector2(0, 0)
	
	
func GetRoomAt(grid_x: int, grid_y: int):
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
		#if room is Room: # Casting
		
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
# CreatePath()
#------------------------------------------------------------------------------
func CreatePath(start_x: int, start_y: int) -> void:
	
	var current_room = rooms[start_y * maze_width + start_x]
	
	# Pathfinding.
	for i in path_length:
		
		if current_room: # Is there valid?
			
			# Where is rando?
			visited_rooms.append(current_room.Visited(Color.brown))
			
			# If we are on 0 or width -1 pop back
		
			
			var next_room = current_room.GetRandomNeighbour() # Can be null.
			
			# Checking for null.
			if next_room:
				
				if next_room.grid_x >= 0 and next_room.grid_x < maze_width and next_room.grid_y >= 0 and next_room.grid_y < maze_width:
					
					var x: int = 0
					var y: int = 0
					var delta_direction: Vector2 = Vector2.ZERO

					next_room.Visited(Color.forestgreen)
								
					delta_direction = GetDeltaDirection(current_room, next_room)
					
					delta_direction = delta_direction * 2
					current_room = GetRoomAt(current_room.grid_x + delta_direction.x, current_room.grid_y + delta_direction.y)
					
					if !current_room:
						break
				
			else:
				next_room = visited_rooms.pop_back() # Rewind.
				
				# Check for Zero?
					
		else:
			current_room = visited_rooms.pop_back() # Rewind.
			
