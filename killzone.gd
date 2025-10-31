extends Area2D

@onready var timer = $Timer #path timer
@onready var control = %CanvasLayer/Control
# tambah node signal body_entered

func _on_body_entered(body):
	if body.name == "Player":
		$Hit.play()
		body.action(Color.RED)
		print(SignalBus.health)
		SignalBus.life.emit()
		
		if SignalBus.health <= 0:
			Engine.time_scale = 0.5
			body.die()
			body.get_node("Player").queue_free()
			timer.start()

# tambah node signal timeout
func _on_timer_timeout(): # timer selesai
	Engine.time_scale = 1.0 # mengembalikkan slowmo ke normal
	SignalBus.transition = true
	await get_tree().create_timer(1).timeout
	if(get_tree().current_scene.name == "Game0"):
		get_tree().change_scene_to_file("res://scenes/over_0.tscn")
	elif(get_tree().current_scene.name == "Game"):
		get_tree().change_scene_to_file("res://scenes/1.tscn") # reload scene dan restart
	elif(get_tree().current_scene.name == "Game2"):
		get_tree().change_scene_to_file("res://scenes/2.tscn")
	elif(get_tree().current_scene.name == "Game3"):
		get_tree().change_scene_to_file("res://scenes/3.tscn")
	elif(get_tree().current_scene.name == "Game4"):
		get_tree().change_scene_to_file("res://scenes/4.tscn")
