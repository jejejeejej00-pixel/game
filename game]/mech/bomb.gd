extends CharacterBody2D

@onready var player = $"../CharacterBody2D"
@onready var area = $Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if is_instance_valid(player):
		if area.overlaps_body(player):
			player.take_damage(1)
			queue_free()
