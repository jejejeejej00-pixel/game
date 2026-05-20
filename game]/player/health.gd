extends Node2D

@onready var health1 = $"health 1"
@onready var health2 = $"health 2"
@onready var health3 = $"health 3"
@onready var player = $"../CharacterBody2D"


func _process(_float) -> void:
	if is_instance_valid(player):
		if player.health == 3:
			pass
		elif player.health == 2:
			health3.modulate.a = 1
		elif player.health == 1:
			health2.modulate.a = 1
		else:
			health1.modulate.a = 1
			player.queue_free()
			print("game over")
	position.y = $"../CameraOnDeath".position.y
