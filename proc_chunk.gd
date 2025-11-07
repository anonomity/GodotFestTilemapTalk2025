extends Node2D

@export var chunk_width = 20
var chunk_height =  chunk_width
@export var chunk_size = 50

const CHUNK_LAYER = preload("uid://bph7d4bmwnwt")
@onready var chunk_container: Node2D = $ChunkContainer
@onready var noise_texture_rect: TextureRect = $NoiseTextureRect
@onready var thread_checker: Timer = $thread_checker

var threads = []
var chunks = []

func _ready() -> void:
	thread_checker.timeout.connect(check_thread)
	set_chunks()
	
# Called when the node enters the scene tree for the first time.
func set_chunks():
	var noise_text : NoiseTexture2D= noise_texture_rect.texture
	var noise = noise_text.noise
	print("starting")
	for x in chunk_width:
		for y in chunk_height:
			
			var chunk_layer = CHUNK_LAYER.instantiate()
			#var new_thread = Thread.new()
			#threads.append(new_thread)
			#new_thread.start(gen_chunk.bind(chunk_layer, x,y, noise))
			#var task_id = WorkerThreadPool.add_group_task(gen_chunk.bind(chunk_layer, x,y, noise),10)
			#WorkerThreadPool.wait_for_group_task_completion(task_id)
			chunk_layer.chunk_coord = Vector2i(x,y)
			chunk_layer.generate(noise)
			chunks.append(chunk_layer)

	for chunk in chunks:
		chunk_container.add_child(chunk)


	
func gen_chunk(chunk_layer, x , y , noise):
	chunk_layer.chunk_size = chunk_size
	chunk_layer.chunk_coord = Vector2i(x,y)
	chunk_layer.generate(noise)
	chunks.append(chunk_layer)

	
func check_thread():

	for thread in threads:
		if thread.is_alive():
			return

	for chunk in chunks:
		chunk_container.add_child(chunk)

	for thread in threads:
		thread.wait_to_finish()



	thread_checker.queue_free()
