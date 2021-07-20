extends Spatial
class_name Maze

const ROOM_PS: PackedScene = preload("res://Maze/assets/Room.tscn")

var maze_width: int = 5
var maze_height: int = 5



func _ready():
	var room: Room = ROOM_PS.instance()
	add_child(room)

