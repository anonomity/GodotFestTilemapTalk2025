@tool
extends Resource
class_name TileSave

@export var terrain_dict = {}

# vec 3 = pos arr
@export var tile_dict = {}

# vec 2 = pos arr
@export var scene_tile_dict = {}

func save_terrains(_terrain_dict : Dictionary[Vector2i, Array]):
	for key in _terrain_dict:
		if !terrain_dict.has(key):
			terrain_dict[key] = []
		terrain_dict[key] = _terrain_dict[key]

func save_tiles(_tile_dict : Dictionary[Vector3i, Array]):
	for key in _tile_dict:
		if !tile_dict.has(key):
			tile_dict[key] = []
		tile_dict[key] = _tile_dict[key]

func save_scene_tiles(_scene_tile_dict : Dictionary[Vector2i, Array]):
	for key in _scene_tile_dict:
		if !scene_tile_dict.has(key):
			scene_tile_dict[key] = []
		scene_tile_dict[key] = _scene_tile_dict[key]
