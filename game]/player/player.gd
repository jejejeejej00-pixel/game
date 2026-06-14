extends CharacterBody2D

@export var base_speed: float = 350.0
@export var tile_size: int = 32

var target_angle = PI/2

var player_pos = Vector2(5, -30)
var final_cell = Vector2()
var dir = Vector2()

var is_moving = false
var is_invincible = false
var health = 3

var current_speed: float = base_speed
var score: int = 0

@onready var sprite = $Sprite2D
@onready var map = $".."

func _ready() -> void:
	position = player_pos * tile_size
	final_cell = player_pos
	print_score()
	

func rotato():
	if dir == Vector2.UP:
		target_angle = -PI / 2
	elif dir == Vector2.RIGHT:
		target_angle = 0
	elif dir == Vector2.DOWN:
		target_angle = PI/2
	else: target_angle = PI

func moving(direction):
	var next_cell = player_pos + direction
	var tile_type = get_tile_type(next_cell)
	
	if tile_type == "":
		dir = direction
		final_cell = next_cell
		rotato()
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
		
func print_score():
	print(current_speed,' ', score)
	print($"..".current_speed)
	await get_tree().create_timer(5).timeout
	print_score()

func _process(delta: float) -> void:
	sprite.rotation = lerp_angle(sprite.rotation, target_angle, 20 * delta)
	sprite.position = Vector2(16,16)
	
	score = round(player_pos[1])
	if base_speed * (1 + float(score)/100) < 700.0:
		current_speed = base_speed * (1 + float(score)/100.0)
	else:
		current_speed = 700.0
	
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
	
	health -= amount
	is_invincible = true
	
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.15).timeout
	sprite.modulate = Color.WHITE
	sprite.modulate.a = 0.5
	
	await get_tree().create_timer(1.5).timeout
	sprite.modulate.a = 1
	is_invincible = false

func heal(amount):
	
	health += amount
	
	sprite.modulate = Color.GREEN
	await get_tree().create_timer(0.15).timeout
	sprite.modulate = Color.WHITE
