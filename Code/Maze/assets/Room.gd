extends Spatial
class_name Room

# TODO: Ref to Main help keep the object oriented aspects?

var visited: bool = false
var grid_x: int = 0
var grid_y: int = 0

#------------------------------------------------------------------------------
# Pure setter for visited. The only way to "unvisit" should be using Reset().
#------------------------------------------------------------------------------
func Visit() -> void:
	visited = true;

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
# SetFloorColor()
#------------------------------------------------------------------------------
func ColorFloor(color: Color) -> void:
	$Floor.get_surface_material(0).set_shader_param("BaseColor", color)
