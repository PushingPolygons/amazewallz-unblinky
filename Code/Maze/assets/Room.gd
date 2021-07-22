extends MeshInstance
class_name Room

var grid_x: int = 0
var grid_y: int = 0
var neighbours: Array = [] # Room.


func AddNeighbour(room: Room) -> void:
	neighbours.append(room)

func Visited():
	pass
