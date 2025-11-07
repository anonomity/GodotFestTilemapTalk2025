extends TileMapLayer

@onready var procedural_generation: Node2D = $ProceduralGeneration

var chunk_coord = Vector2i.ZERO
var chunk_size = 50

var grass_range = Vector2(-2.0, -0.1)
var sand_range = Vector2(-0.1, 0.3)
var rock_range = Vector2(0.3, 0.9)

var grass_arr = []
var sand_arr = []
var rock_arr = []


func generate(noise : Noise):
	grass_arr = []
	sand_arr = []
	rock_arr = []
	global_position = Vector2(chunk_coord.x * chunk_size, chunk_coord.y * chunk_size) * 16
	#print("###############################################chunk coords ", chunk_coord)
	for x in range(-1, chunk_size + 1):
		for y in range(-1, chunk_size + 1):
			var noise_tile_pos =  chunk_coord * chunk_size + Vector2i(x,y)
			var normal_tile_pos =  Vector2i(x,y)
			#print(" tile pos ", tile_pos)
			var noise_val = noise.get_noise_2d(noise_tile_pos.x, noise_tile_pos.y)
			set_proper_tile(noise_val,normal_tile_pos)

	set_cells()
	
	for i in range(-1, chunk_size+2):
		erase_cell(Vector2(-1, (i-1)))

	for j in range(-1, chunk_size+2):
		erase_cell(Vector2((j-1), -1 ))

	

func set_proper_tile(noise_val : float, normal_tile_pos):

	if is_in_range(grass_range, noise_val):
		grass_arr.append(normal_tile_pos)
		#var rand =  randf_range(0.0,1.0)
		#if rand >0.7:
			#scene_tile_map_layer.set_cell(tile_pos, 0, Vector2.ZERO, 1)
	elif is_in_range(sand_range, noise_val):
		sand_arr.append(normal_tile_pos)
	elif is_in_range(rock_range, noise_val):
		rock_arr.append(normal_tile_pos)
	else:
		grass_arr.append(normal_tile_pos)
		print("nuthin ", noise_val)
		
	#var rand =  randf_range(0.0,1.0)
	#if rand >0.9:
		#print("setting")
		#tile_tile_map_layer.set_cell(tile_pos, 0, random_mushroom.pick_random())

func set_cells():
	set_cells_terrain_connect(grass_arr, 0,0,false)
	set_cells_terrain_connect(sand_arr, 0,1,false)
	set_cells_terrain_connect(rock_arr, 0,2,false)

func is_in_range(range : Vector2, noise_val):
	if noise_val > range.x and noise_val < range.y:
		return true
	else:
		return false
