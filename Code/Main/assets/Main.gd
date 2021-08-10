extends Node

const MAZE_PS: PackedScene = preload("res://Maze/Maze.tscn")
var maze: Maze = null

func _ready() -> void:
	maze = MAZE_PS.instance()
	add_child(maze)
	
# Reset Syetem.
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		ResetMaze()
		

func ResetMaze() -> void:
	maze.queue_free()
	
	maze = MAZE_PS.instance()
	add_child(maze)
	
