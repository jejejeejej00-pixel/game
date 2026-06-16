extends CharacterBody2D

@onready var player = $"../CharacterBody2D"
@onready var area = $Area2D

func _process(_delta) -> void:
	if is_instance_valid(player):
		if area.overlaps_body(player):
			player.heal(1)
			queue_free()
