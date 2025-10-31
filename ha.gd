extends Area2D

@export var textures : Array[Texture] = []
@export var hanacaraka = false
@export var color = Color.BLACK
@onready var timer = $Timer
#signal untuk dikirim

var word_taken = false

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		if word_taken == false:
			body.take()
			body.action(Color.RED)
			$Audio.play()
			word_taken = true
			$Sprite.queue_free()
			print(SignalBus.health)
			SignalBus.life.emit()

			if SignalBus.health <= 0:
				Engine.time_scale = 0.5
				body.die()
				body.get_node("Player").queue_free()
				timer.start()


func _on_timer_timeout(): # timer selesai
	Engine.time_scale = 1.0 # mengembalikkan slowmo ke normal
	if(get_tree().current_scene.name == "Game"):
		get_tree().change_scene_to_file("res://scenes/1.tscn") # reload scene dan restart
	elif(get_tree().current_scene.name == "Game2"):
		get_tree().change_scene_to_file("res://scenes/2.tscn")
	elif(get_tree().current_scene.name == "Game3"):
		get_tree().change_scene_to_file("res://scenes/3.tscn")
	elif(get_tree().current_scene.name == "Game4"):
		get_tree().change_scene_to_file("res://scenes/4.tscn")

func _on_ready() -> void:
	randomize()
	var randomSprite = textures[randi() % textures.size()]
	$Sprite.texture = randomSprite
	$Sprite.modulate = color
	$AnimationPlayer.play("fly")
	#mengambil random texture
