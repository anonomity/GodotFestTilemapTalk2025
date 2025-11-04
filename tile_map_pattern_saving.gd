@tool
extends TileMapLayer

@export var pattern_res : TileMapPattern
@export var pattern_and_pos : PatternAndPos

@export_tool_button("Save Everything") var save_everything_res = save_with_pattern
@export_tool_button("Load Everything") var load_everything_res = load_pattern
@export_tool_button("Clear Everything") var clear_all_tiles = clear_tiles

class PatternAndPos extends Resource:
	@export var position: Vector2i
	@export var pattern : TileMapPattern

var top_left 

func clear_tiles():
	clear()
	
func save_with_pattern():
	var to_save = PatternAndPos.new()
	to_save.position = get_used_rect().position
	to_save.pattern = get_pattern(get_used_cells())
	pattern_and_pos = to_save
	
	#pattern_res = get_pattern(get_used_cells())
	#top_left = get_top_left(get_used_cells())

	#ResourceSaver.save(pattern, "res://my_pattern.tres")

func load_pattern():
	#pattern = load("res://my_pattern.tres")
	#set_pattern(top_left,pattern_res)
	set_pattern(pattern_and_pos.position,pattern_and_pos.pattern)
	#map_pattern(Vector2i(0,0), Vector2i(0,0), pattern_res)

func get_top_left(cell_arr):
	var furthest_x= 1000000000
	var furthest_y= 1000000000
	var top_left_pos 
	for pos in cell_arr:
		if pos.x < furthest_x and pos.y < furthest_y:
			furthest_y = pos.y
			furthest_x = pos.x
			top_left_pos = pos
	return top_left_pos

	
