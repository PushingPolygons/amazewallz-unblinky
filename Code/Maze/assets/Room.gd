extends Spatial
class_name Room

var visited: bool = false
var grid_x: int = 0
var grid_y: int = 0
var neighbours: Array = [] # An array of Room elements.

#------------------------------------------------------------------------------
# DropWall() will hide the wall in the specified direction.
#------------------------------------------------------------------------------
func DropWall(direction):
	match direction:
		Directions.UP:
			$WallUp.hide()
			
		Directions.DOWN:
			$WallDown.hide()
			
		Directions.LEFT:
			$WallLeft.hide()
			
		Directions.RIGHT:
			$WallRight.hide()

#------------------------------------------------------------------------------
# Retuns a valid (non-visited) Room instance from the neighbours[].
# Returns null if there are no elements in the array.
#------------------------------------------------------------------------------
func GetRandomNeighbour() -> Room:
	
	for neighbour in neighbours:
				
		if neighbours.size() > 0:
		
			var rando = randi() % neighbours.size()
			var room: Room = neighbours[rando]
			
			if room.visited:
				neighbours.remove(rando)
			else:
				neighbours.remove(rando)
				return room
				
	return null

		
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func AddNeighbour(room) -> void:
	neighbours.append(room)

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func ColorNeighbours(color: Color) -> int:
	for neighbour in neighbours:
		neighbour.get_surface_material(0).set_shader_param("BaseColor", color)
			
	return neighbours.size()
	
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func Visited(color: Color):
	$Floor.get_surface_material(0).set_shader_param("BaseColor", color)
	visited = true
	return self
	
