extends Spatial
class_name Maze

const ROOM_PS: PackedScene = preload("res://Maze/assets/Room.tscn")

var maze_width: int = 5
var maze_height: int = 5

var rooms: Array = []


func _ready():
	
	for y in maze_height:
		for x in maze_width:
			var room: Room = ROOM_PS.instance()
			room.translation = Vector3(x, 0, y)
			rooms.append(room)
			add_child(room)
