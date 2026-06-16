extends Control

@onready var sound = $"../../AudioStreamPlayer"
@onready var sfx1 = $"../../../heal"
@onready var sfx2 = $"../../../damage"
@onready var fullGame = $"../../../.."

func _on_button_4_pressed() -> void:
	$"../Button".button_pressed = false
	$"../..".get_tree().paused = false
	hide()

func _on_button_pressed() -> void:
	if sound.playing:
		sound.playing = false
	else:
		sound.playing = true

func _on_button_2_pressed() -> void:
	if $"../..".k:
		$"../..".k = false
	else:
		$"../..".k = true


func _on_button_3_pressed() -> void:
	$"../Button".button_pressed = false
	fullGame.game_menu()
	get_tree().paused = false
	hide()
