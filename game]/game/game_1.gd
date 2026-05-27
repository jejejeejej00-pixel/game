extends Node2D

@onready var map = $"."
@onready var player = $CharacterBody2D
@onready var spike_wall = $Spikes

@export var chunk_folder_path: String = "res://game]/Chunks/"
@export var render_distance : int = 8 # радиус прорисовки
@export var start_speed : float = 50

var available_chunks: Array[PackedScene] = []
var last_chunk_y: float = 0
var chunk_height: float = 10 # высота одного чанка

var tile_size : int = 32
var current_speed : float = start_speed

func _ready():
	load_all_chunks()
	spike_wall.global_position.y = position.y - 8 * tile_size

func _process(delta: float) -> void:
	if is_instance_valid(player):
		if last_chunk_y < player.position.y / 32 + render_distance :
			spawn_random_chunk()
		if player.position.y - spike_wall.position.y <= 16:
			player.take_damage(1)
			spike_wall.global_position.y -= 32 * render_distance*4
			if player.dir.y == -1:
				player.dir.y = 1
				player.is_moving = false
				player.moving(Vector2.DOWN)
				
	current_speed = start_speed + (float(player.score)/1000)
	spike_wall.global_position.y += current_speed * delta
	
	if spike_wall.global_position.y < player.global_position.y - 11 * tile_size:
		spike_wall.global_position.y = player.global_position.y - 10 * tile_size

func load_all_chunks():
	var dir = DirAccess.open(chunk_folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				var chunk_scene = load(chunk_folder_path + file_name)
				available_chunks.append(chunk_scene)
			file_name = dir.get_next()

func spawn_random_chunk():

	var random_scene = available_chunks.pick_random()
	var chunk_instance: TileMapLayer = random_scene.instantiate()
	
	set_chunk_on_map(chunk_instance)
	last_chunk_y += chunk_height
	
	for x in range(0, 12):
		for y in range(0, 10):
			map.erase_cell(Vector2i(x , last_chunk_y - render_distance * 5 - y))
	
func set_chunk_on_map(chunk_instance):
	var used_cells: Array[Vector2i] = chunk_instance.get_used_cells()
	var offset: Vector2i = Vector2(0,last_chunk_y)
	
	for cell in used_cells:
		var original_id = chunk_instance.get_cell_source_id(cell)
		var atlas_coords: Vector2i = chunk_instance.get_cell_atlas_coords(cell)
		var global_pos: Vector2i = cell + offset
		
		map.set_cell(global_pos, original_id, atlas_coords)
