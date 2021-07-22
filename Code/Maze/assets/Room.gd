extends MeshInstance
class_name Room

var visited: bool = false
var grid_x: int = 0
var grid_y: int = 0
var neighbours: Array = [] # Room.



func GetUnvisitedNeighbour() -> Room:
	neighbours.shuffle()
	for neighbour in neighbours:
		if neighbour.visited == false:
			return neighbour
	
	return null
	

func AddNeighbour(room: Room) -> void:
	neighbours.append(room)


func ColorNeighbours(color: Color) -> int:
	for neighbour in neighbours:
		neighbour.get_surface_material(0).set_shader_param("BaseColor", color)
			
	return neighbours.size()
	
	
func ColorRoom(color: Color):
	get_surface_material(0).set_shader_param("BaseColor", color)
