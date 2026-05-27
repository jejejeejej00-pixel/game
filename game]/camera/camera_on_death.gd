extends Camera2D

@onready var player = $"../CharacterBody2D"
@onready var other_camera = $"../CharacterBody2D/Camera2D"

func _ready() -> void:
	enabled = false
	position = Vector2(192,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_float) -> void:
	if is_instance_valid(player):
		position.y = player.position.y
	else:
		set_enabled(true)
