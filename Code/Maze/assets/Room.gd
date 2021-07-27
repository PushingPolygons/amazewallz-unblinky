extends MeshInstance
class_name Room

var visited: bool = false
var grid_x: int = 0
var grid_y: int = 0
var neighbours: Array = [] # Room.



func GetRandomNeighbour() -> Room:
	if neighbours.size() > 0:
	
		var rando = randi() % neighbours.size()
		var room: Room = neighbours[rando]
		neighbours.remove(rando)
		
		return room
	else:
		return null
	

func AddNeighbour(room: Room) -> void:
	neighbours.append(room)


func ColorNeighbours(color: Color) -> int:
	for neighbour in neighbours:
		neighbour.get_surface_material(0).set_shader_param("BaseColor", color)
			
	return neighbours.size()
	
	
func Visited(color: Color) -> Room:
	get_surface_material(0).set_shader_param("BaseColor", color)
	visited = true
	return self
