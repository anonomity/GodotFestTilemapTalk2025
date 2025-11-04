@tool
extends Node2D

@onready var terrain_layer: TileMapLayer = $TerrainTileMapLayer
@onready var scene_tile_map_layer: TileMapLayer = $SceneTileMapLayer
@onready var tile_tile_map_layer: TileMapLayer = $TileTileMapLayer

@export var tile_save : TileSave
	
@export_tool_button("Clear Terrain Tilemap") var clear = clear_tilemap

@export_tool_button("Save Everything") var save_everything_res = save_everything
@export_tool_button("Load Everything") var load_everything_res = load_everything

@export_tool_button("Save Tilemap Resource") var save_res = save_terrains
@export_tool_button("Load Tilemap Resource") var load_res = load_terrains

@export_tool_button("Save Tilemap TILE Resource") var save_tile_res = save_tile_layer
@export_tool_button("Load Tilemap TILE Resource") var load_tile_res = load_tiles

@export_tool_button("Save Tilemap SCENE Resource") var save_scene_tile_res = save_scene_layer
@export_tool_button("Load Tilemap SCENE Resource") var load_scene_tile_res = load_scene_tiles

func clear_tilemap():
	terrain_layer.clear()
	tile_tile_map_layer.clear()
	scene_tile_map_layer.clear()

func save_everything():
	save_terrains()
	save_tile_layer()
	save_scene_layer()

func load_everything():
	load_scene_tiles()
	load_tiles()
	load_terrains()

func save_terrains():
	var terrain_dict : Dictionary[Vector2i, Array] = {}
	for tile_pos in terrain_layer.get_used_cells():
		var tile_data : TileData = terrain_layer.get_cell_tile_data(tile_pos)
		var terrain_vec = Vector2i(tile_data.terrain_set,tile_data.terrain)
		if !terrain_dict.has(terrain_vec):
			terrain_dict[terrain_vec] = []
		var tile_arr = terrain_dict[terrain_vec]
		tile_arr.append(tile_pos)
		terrain_dict[terrain_vec] = tile_arr
	if tile_save:
		tile_save.save_terrains(terrain_dict)

func save_tile_layer():
	var tile_dict : Dictionary[Vector3i, Array] = {}
	for tile_pos in tile_tile_map_layer.get_used_cells():
		var source_id : int = tile_tile_map_layer.get_cell_source_id(tile_pos)
		var atlas_coords : Vector2i = tile_tile_map_layer.get_cell_atlas_coords(tile_pos)
		var tile_vec = Vector3i(source_id, atlas_coords.x, atlas_coords.y)
		if !tile_dict.has(tile_vec):
			tile_dict[tile_vec] = []
		var tile_arr = tile_dict[tile_vec]
		tile_arr.append(tile_pos)
		tile_dict[tile_vec] = tile_arr
	if tile_save:
		tile_save.save_tiles(tile_dict)

func save_scene_layer():
	var scene_tile_dict : Dictionary[Vector2i, Array] = {}
	for tile_pos in scene_tile_map_layer.get_used_cells():
		var source_id : int = scene_tile_map_layer.get_cell_source_id(tile_pos)
		var alternative_id : int = scene_tile_map_layer.get_cell_alternative_tile(tile_pos)
		var scene_tile_vec = Vector2i(source_id, alternative_id)
		print("scene tile vec  ", scene_tile_vec)
		if !scene_tile_dict.has(scene_tile_vec):
			scene_tile_dict[scene_tile_vec] = []
		var tile_arr = scene_tile_dict[scene_tile_vec]
		tile_arr.append(tile_pos)
		scene_tile_dict[scene_tile_vec] = tile_arr
	if tile_save:
		tile_save.save_scene_tiles(scene_tile_dict)

func load_tiles():
	if tile_save:
		for key in tile_save.tile_dict:
			var tile_vec : Vector3i = key
			var cell_arr = tile_save.tile_dict[key]
			for tile_pos in cell_arr:
				tile_tile_map_layer.set_cell(tile_pos, tile_vec.x, Vector2i(tile_vec.y, tile_vec.z))

func load_scene_tiles():
	if tile_save:
		for key in tile_save.scene_tile_dict:
			var tile_vec : Vector2i = key
			var cell_arr = tile_save.scene_tile_dict[key]
			for tile_pos in cell_arr:
				print(tile_pos, tile_vec.x, Vector2i.ZERO, tile_vec.y)
				scene_tile_map_layer.set_cell(tile_pos, tile_vec.x, Vector2i.ZERO, tile_vec.y)

func load_terrains():
	if tile_save:
		for key in tile_save.terrain_dict:
			var terrain_vec : Vector2i = key
			var cell_arr = tile_save.terrain_dict[key]
			terrain_layer.set_cells_terrain_connect(cell_arr, terrain_vec.x, terrain_vec.y,false)
		
	
	
