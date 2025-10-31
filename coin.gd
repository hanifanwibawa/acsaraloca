extends Area2D

@onready var game_manager = %GameManager
@onready var animation_player = $AnimationPlayer
# tambah node signal body_entered
func _on_body_entered(body):
	if body.name == "Player" :
		body.take()
		body.action(Color.YELLOW)
		game_manager.add_point() # coin dimasukkan ke game_manager
		animation_player.play("pickup") # mendapatkan coin dengan suara
	# queue_free() diganti
	# queue free digunakan untuk menghilangkan coin ketika dipickup
