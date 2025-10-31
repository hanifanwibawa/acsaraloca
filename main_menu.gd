extends Node2D

@export var textures : Array[Texture] = []
@export var changeScene: PackedScene
@export var tutorialScene: PackedScene
@onready var anim = $CanvasLayer2/AnimationPlayer

var Tier


func _on_play_button_down() -> void:
	SignalBus.coins = 0
	SignalBus.health = 3
	print(SignalBus.health)
	if(get_tree().current_scene.name == "Game0" || get_tree().current_scene.name == "Game" ||get_tree().current_scene.name == "Game2" || get_tree().current_scene.name == "Game3" || get_tree().current_scene.name == "Game4"):
		get_tree ().reload_current_scene ()
	else:
		SignalBus.transition = true
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_packed(changeScene)
	
#apabila menekan button play

func _on_quit_button_down() -> void:
	get_tree().quit()
#apabila menekan button quit

func _on_menu_button_down() -> void:
	SignalBus.transition = true
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menu_main.tscn")
#apabila menekan button menu

func _ready() -> void:
	SignalBus.health = 3
	if(textures.size() != 0):
		randomize()
		var randomSprite = textures[randi() % textures.size()]
		$CanvasLayer2/Control/Sprite2D.texture = randomSprite
	if anim != null:
		anim.play("Backgound")
	Engine.time_scale = 1.0
	if(get_tree().current_scene.name == "Game0"):
		SignalBus.level = 0
	elif(get_tree().current_scene.name == "Game"):
		SignalBus.level = 1
	elif(get_tree().current_scene.name == "Game2"):
		SignalBus.level = 2
	elif(get_tree().current_scene.name == "Game3"):
		SignalBus.level = 3
	elif(get_tree().current_scene.name == "Game4"):
		SignalBus.level = 4
	$CanvasLayer2/MarginContainer/VBoxContainer/Label2.text = "COIN : %d" %SignalBus.coins
	if(SignalBus.coins < 10 && SignalBus.coins > 0):
		Tier = "Anda Mendapatkan\n Hadiah Tier B"
	elif (SignalBus.coins > 10 && SignalBus.coins < 20):
		Tier = "Anda Mendapatkan\n Hadiah Tier A"
	elif (SignalBus.coins > 20):
		Tier = "Anda Mendapatkan\n Hadiah Tier S"
	else:
		Tier = "Anda Tidak \n Mendapatkan Hadiah"
	$CanvasLayer2/MarginContainer/VBoxContainer/Label3.text = "%s" %Tier


func _on_tutorial_button_down() -> void:
	get_tree().change_scene_to_packed(tutorialScene)


func _on_restart_button_down() -> void:
	SignalBus.coins = 0
	get_tree ().reload_current_scene ()
