extends CharacterBody2D

@onready var player = $"../CharacterBody2D"
@onready var area = $Area2D

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if area.overlaps_body(player):
		player.heal(1)
		queue_free()
