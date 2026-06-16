extends Control

@onready var button = $Button
@onready var fullGame = $"../.."

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if button.button_pressed:
		print("привет")
		button.disabled = true
		fullGame.start_game_round()
	
	if fullGame.score == 0:
		$RichTextLabel.text = ""
	else:
		$RichTextLabel.text = str(fullGame.score)
		$Container.show()

func able_button():
	button.disabled = false
