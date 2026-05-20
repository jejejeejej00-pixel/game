extends CharacterBody2D

@export var base_speed = 500.0
@export var tile_size = 32

var player_pos = Vector2(1, 0)
var final_cell = Vector2()
var dir = Vector2()

var is_moving = false
var is_invincible = false
var health = 3

var current_speed: float = 500.0
var score: int = 0

@onready var sprite = $Sprite2D
@onready var map = $".."

func _ready() -> void:
	position = player_pos * tile_size
	final_cell = player_pos

func moving(direction):
	var next_cell = player_pos + direction
	var tile_type = get_tile_type(next_cell)
	
	
	if tile_type == "":
		dir = direction
		final_cell = next_cell
		is_moving = true
	else:
		if tile_type == "Damage":
			take_damage(1)

func waiting_input():
	if Input.is_action_pressed("ui_up"):
		moving(Vector2.UP)
	elif Input.is_action_pressed("ui_left"):
		moving(Vector2.LEFT)
	elif Input.is_action_pressed("ui_down"):
		moving(Vector2.DOWN)
	elif Input.is_action_pressed("ui_right"):
		moving(Vector2.RIGHT)

func _process(delta: float) -> void:
	
	score = round(player_pos[1])
	current_speed = base_speed * (1 + float(score)/1000)
	
	if is_moving:
		position += dir * current_speed * delta
		
		# Если доехали до центра клетки
		if position.distance_to(final_cell * tile_size) < 5.0:
			player_pos = final_cell
			position = player_pos * tile_size
			
			var next_cell = player_pos + dir
			var tile_type = get_tile_type(next_cell)
			
			if tile_type == "":
				final_cell = next_cell
			else:
				is_moving = false
				dir = Vector2.ZERO
				
				if tile_type == "Damage":
					take_damage(1)
	else:
		waiting_input()
		
func get_tile_type(cell):
	if map.get_cell_source_id(cell) == 0:
		return "Terrain"
	var tile_data = map.get_cell_tile_data(cell)
	if tile_data:
		var data = tile_data.get_custom_data("damage_type")
		return data if data else ""
		
	return ""
	
func take_damage(amount):
	if is_invincible or health <= 0: return
	
	health -= 0 #amount
	is_invincible = true
	
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.15).timeout
	sprite.modulate = Color.WHITE
	sprite.modulate.a = 0.5
	
	await get_tree().create_timer(1.5).timeout
	sprite.modulate.a = 1
	is_invincible = false
