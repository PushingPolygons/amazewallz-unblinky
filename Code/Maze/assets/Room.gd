extends Spatial
class_name Room

var visited: bool = false
var grid_x: int = 0
var grid_y: int = 0

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
#------------------------------------------------------------------------------
func Reset(color: Color) -> void:
	ColorFloor(color)
	$WallUp.show()
	$WallDown.show()
	$WallLeft.show()
	$WallRight.show()


#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func ColorFloor(color: Color) -> void:
	$Floor.get_surface_material(0).set_shader_param("BaseColor", color)


#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func Visit(color: Color):
	ColorFloor(color)
	visited = true
	return self
	
