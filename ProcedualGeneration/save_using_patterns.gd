@tool
extends Node2D

@export var pattern_and_pos : PatternAndPos

@export_tool_button("Save Everything") var save_everything_res = save_everything
@export_tool_button("Load Everything") var load_everything_res = load_everything
@export_tool_button("Clear Everything") var clear_all_tiles = clear_tiles

@export var tiles_to_save : Array[TileMapLayer]

func save_everything():
	for tile_layer in tiles_to_save:
		save_with_pattern(tile_layer)
		
func load_everything():
	for tile_layer in tiles_to_save:
		load_pattern(tile_layer)

func clear_tiles():
	for tile_layer in tiles_to_save:
		tile_layer.clear()
	
func save_with_pattern(tile_layer : TileMapLayer):
	if pattern_and_pos == null:
		pattern_and_pos = PatternAndPos.new()
	pattern_and_pos.position = tile_layer.get_used_rect().position
	pattern_and_pos.pattern = tile_layer.get_pattern(tile_layer.get_used_cells())
	
	ResourceSaver.save(pattern_and_pos, "user://"+str(tile_layer.name)+".tres")

func load_pattern(tile_layer : TileMapLayer):
	var pattern : PatternAndPos = ResourceLoader.load("user://"+str(tile_layer.name)+".tres")
	tile_layer.set_pattern(pattern.position,pattern.pattern)
