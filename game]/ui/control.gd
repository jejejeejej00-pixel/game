extends Control

@onready var button = $Button
@onready var fullGame = $"../.."

func _ready() -> void:
	button.position = Vector2i(262,200)
	button.size = Vector2i(264,152)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if button.button_pressed:
		print("привет")
		button.disabled = true
		fullGame.start_game_round()

func able_button():
	button.disabled = false
