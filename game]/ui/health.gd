extends CanvasLayer

@onready var player = $"../CharacterBody2D"
@onready var fullGame = $"../.."
@onready var button2 = $Container/Button

var constant = 3
var k = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.playing = fullGame.music
	k = fullGame.sf

func _process(_delta) -> void:
	fullGame.sf = k
	fullGame.music = $AudioStreamPlayer.playing
	if is_instance_valid(player):
		if constant != player.health:
			change_health()
		$Container/RichTextLabel.text = str(player.score)
	if button2.button_pressed or Input.is_action_just_pressed("ui_cancel"):
		$Container/menu.show()
		get_tree().paused = true
		
		

func change_health():
	if player.health < 3:
		$Container/heart3.visible = false
	else: $Container/heart3.visible = true
	
	if player.health < 2:
		$Container/heart2.visible = false
	else: $Container/heart2.visible = true
	
	if player.health < 1:
		$Container/heart1.visible = false
		player.queue_free()
		fullGame.game_menu()
	else: $Container/heart1.visible = true
	
	if player.health > 3:
		player.health = 3
	
	constant = player.health
	
	# print("здоровье: ", player.health)

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		# print("Игра свернута или вкладка неактивна!")
		$Container/menu.show()
		get_tree().paused = true
