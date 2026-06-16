extends Node2D

@onready var bs = $CanvasLayer/Sprite2D
@onready var control = $CanvasLayer/Control
@onready var button = $CanvasLayer/Control/Button

@export var node_scene : PackedScene
var active_node: Node

var music = true
var sf = true

var score : int = 0

func _ready() -> void:
	await YandexSDK.init()
	fade_in()

func fade_in():
	for x in range(0,50):
		bs.modulate.a = 1 - float(x*2)/100.0
		await get_tree().create_timer(0).timeout

func start_game_round():
	for x in range(0,50):
		bs.modulate.a = float(x*2)/100.0
		await get_tree().create_timer(0.01).timeout
	
	active_node = node_scene.instantiate()
	add_child(active_node)
	
	control.hide()
	control.set_process(false)
	await get_tree().create_timer(0.5).timeout
	fade_in()

func game_menu():
	for x in range(0,50):
		bs.modulate.a = float(x*2)/100.0
		await get_tree().create_timer(0.01).timeout
	control.show()
	control.set_process(true)
	active_node.queue_free()
	await get_tree().create_timer(0.5).timeout
	control.able_button()
	YandexSDK.adv.show_fullscreen()
	fade_in()
