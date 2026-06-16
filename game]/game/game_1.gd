extends Node2D

const bomb = preload("res://game]/mech/bomb.tscn")
const heal = preload("res://game]/mech/heal.tscn")

@onready var map = $"."
@onready var player = $CharacterBody2D
@onready var spike_wall = $Spikes

@export var chunk_folder_path: Array[String] = [
	"res://game]/Chunks/chunk1(2).tscn", 
	"res://game]/Chunks/chunk1(3).tscn", 
	"res://game]/Chunks/chunk1.tscn", 
	"res://game]/Chunks/chunk2.tscn", 
	"res://game]/Chunks/chunk3(2).tscn", 
	"res://game]/Chunks/chunk3.tscn", 
	"res://game]/Chunks/chunk4(2).tscn", 
	"res://game]/Chunks/chunk4.tscn", 
	"res://game]/Chunks/chunk5.tscn", 
	"res://game]/Chunks/chunk6.tscn", 
	"res://game]/Chunks/chunk7.tscn", 
	"res://game]/Chunks/chunk8.tscn", 
	"res://game]/Chunks/chunk9.tscn", 
	"res://game]/Chunks/chunk10(2).tscn", 
	"res://game]/Chunks/chunk10.tscn"
]
@export var render_distance : int = 8 # радиус прорисовки
@export var start_speed : float = 40

var available_chunks: Array[PackedScene] = []
var last_chunk_y: float = 0
var chunk_height: float = 10 # высота одного чанка

var tile_size : int = 32
var current_speed : float = start_speed

func _ready():
	load_all_chunks()
	spike_wall.global_position.y = player.position.y - 25 * tile_size
	
	await get_tree().create_timer(0.01).timeout
	player.moving(Vector2.DOWN)
	

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
		
		if current_speed < 100:
			current_speed = player.current_speed / 8.00
		else: current_speed = 100
		spike_wall.global_position.y += current_speed * delta
		
		if spike_wall.global_position.y < player.global_position.y - 11 * tile_size:
			spike_wall.global_position.y = player.global_position.y - 10 * tile_size
		if $"..".score < player.score:
			$"..".score = player.score

func load_all_chunks():
	for x in chunk_folder_path:
		var chunk_scene = load(x)
		available_chunks.append(chunk_scene)
		

func spawn_random_chunk():
	var random_scene = available_chunks.pick_random()
	var chunk_instance: TileMapLayer = random_scene.instantiate()
	
	set_chunk_on_map(chunk_instance)
	last_chunk_y += chunk_height
	
	for x in range(0, 12):
		for y in range(0, 10):
			map.erase_cell(Vector2i(x , round(last_chunk_y - render_distance * 5 - y)))
	
func set_chunk_on_map(chunk_instance):
	var used_cells: Array[Vector2i] = chunk_instance.get_used_cells()
	var offset: Vector2i = Vector2(0,last_chunk_y)
	
	for cell in used_cells:
		var original_id = chunk_instance.get_cell_source_id(cell)
		var atlas_coords: Vector2i = chunk_instance.get_cell_atlas_coords(cell)
		var global_pos: Vector2i = cell + offset
		
		map.set_cell(global_pos, original_id, atlas_coords)
		
		if original_id == 2:
			var heal_box = heal.instantiate()
			heal_box.position = global_pos * 32
			add_child(heal_box)
			
		if original_id == 3:
			var bomb_one = bomb.instantiate()
			bomb_one.position = global_pos * 32
			add_child(bomb_one)
			
