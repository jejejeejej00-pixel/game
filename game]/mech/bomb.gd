extends CharacterBody2D

@onready var player = $"../CharacterBody2D"
@onready var area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(player):
		if area.overlaps_body(player):
			player.take_damage(1)
			queue_free()
