extends Spatial
class_name Room

var visited: bool = false
var grid_x: int = 0
var grid_y: int = 0
var neighbours: Array = [] # An array of Room elements.

#------------------------------------------------------------------------------
# Resets the room.
#------------------------------------------------------------------------------
func Reset(color: Color) -> void:
	$Floor.get_surface_material(0).set_shader_param("BaseColor", color)
	$WallUp.show()
	$WallDown.show()
	$WallLeft.show()
	$WallRight.show()
	visited = false
	
#------------------------------------------------------------------------------
# DropWall() will hide the wall for the specified direction.
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
# Returns null if there are no rooms.
#------------------------------------------------------------------------------
func GetRandomNeighbour() -> Room:
	if neighbours.size() > 0:
		var rando = randi() % neighbours.size()
		var room: Room = neighbours[rando]
		neighbours.remove(rando)
		return room
	else:
		return null
	
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func AddNeighbour(room) -> void:
	neighbours.append(room)

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func ColorNeighbours(color: Color) -> int:
	for neighbour in neighbours:
		neighbour.ColorSelf(color)
			
	return neighbours.size()

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func ColorSelf(color: Color) -> void:
	$Floor.get_surface_material(0).set_shader_param("BaseColor", color)
			
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func Visited(color: Color):
	$Floor.get_surface_material(0).set_shader_param("BaseColor", color)
	visited = true
	return self
