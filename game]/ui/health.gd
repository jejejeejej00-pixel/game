extends CanvasLayer

@onready var player = $"../CharacterBody2D"
@onready var fullGame = $"../.."

var constant = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if is_instance_valid(player):
		if constant != player.health:
			change_health()
		
func change_health():
	if player.health < 3:
		$Container/heart3.visible = false
	else: $Container/heart3.visible = true
	
	if player.health < 2:
		$Container/heart2.visible = false
	else: $Container/heart2.visible = true
	
	if player.health < 1:
		$Container/heart1.visible = false
		player.queue_free()
		fullGame.game_menu()
	else: $Container/heart1.visible = true
	
	if player.health > 3:
		player.health = 3
	
	constant = player.health
	
	print("здоровье: ", player.health)
