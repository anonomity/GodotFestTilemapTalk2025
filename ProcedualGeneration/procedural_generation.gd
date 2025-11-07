@tool
extends Node2D

@export_tool_button("Noise Gen") var noise_gen = generate_biome

@onready var noise_texture_rect: TextureRect = $NoiseTextureRect
var noise_texture : NoiseTexture2D
var noise : Noise 

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var scene_tile_map_layer: TileMapLayer = $SceneTileMapLayer
@onready var tile_tile_map_layer: TileMapLayer = $TileTileMapLayer


var random_mushroom = [Vector2i(1,17), Vector2i(2,17), Vector2i(3,17),Vector2i(4,17)]

@export var width = 100
@export var height = 100

var grass_range = Vector2(-2.0, -0.1)
var sand_range = Vector2(-0.1, 0.3)
var rock_range = Vector2(0.3, 0.9)

func _ready() -> void:
	noise_texture = noise_texture_rect.texture
	noise = noise_texture.noise
	generate_biome()
	
func generate_biome():
	tile_map_layer.clear()
	var grass_arr = []
	var sand_arr = []
	var rock_arr = []
	
	var noise_values = []
	for x in width: 
		for y in height:
			var noise_val = noise.get_noise_2d(x,y)
			noise_values.append(noise_val)
			var tile_pos = Vector2i(x,y)
			
			if is_in_range(grass_range, noise_val):
				grass_arr.append(tile_pos)
				var rand =  randf_range(0.0,1.0)
				if rand >0.7:
					scene_tile_map_layer.set_cell(tile_pos, 0, Vector2.ZERO, 1)
			elif is_in_range(sand_range, noise_val):
				sand_arr.append(tile_pos)
			elif is_in_range(rock_range, noise_val):
				rock_arr.append(tile_pos)
			else:
				print("nuthin ", noise_val)
				
			var rand =  randf_range(0.0,1.0)
			if rand >0.9:
				print("setting")
				tile_tile_map_layer.set_cell(tile_pos, 0, random_mushroom.pick_random())
			
	print("max: " , noise_values.max())
	print("min: " , noise_values.min())
	
	print("grass arr ", grass_arr.size())
	print("sand arr ", sand_arr.size())
	print("rock arr ", rock_arr.size())
	
	tile_map_layer.set_cells_terrain_connect(grass_arr, 0,0,false)
	tile_map_layer.set_cells_terrain_connect(sand_arr, 0,1,false)
	tile_map_layer.set_cells_terrain_connect(rock_arr, 0,2,false)
	
func is_in_range(range : Vector2, noise_val):
	if noise_val > range.x and noise_val < range.y:
		return true
	else:
		return false
	
