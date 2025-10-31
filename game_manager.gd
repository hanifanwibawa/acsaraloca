extends Node

var score = SignalBus.coins
var ha = 0

@onready var score_label = $"../Control/ScoreLabel"
@onready var ha_label = $Ha
@onready var na_label = $Na
@onready var ca_label = $Ca

func add_point():
	score += 1
	score_label.text = str(score)
	SignalBus.coins += 1
	# mencetak score sesuai koin yang dikumpulkan

func _on_ha_words(add: int) -> void:
	ha_label.visible = false


func _on_na_words(add: int) -> void:
	na_label.visible = false


func _on_ha_ha(str: Variant) -> void:
	ha_label.text = str(str)


func _on_na_ha(str: Variant) -> void:
	na_label.text = str(str)


func _on_ha_true_words(add: Variant) -> void:
	ha_label.visible = false


func _on_ha_true_2_words(add: Variant) -> void:
	na_label.visible = false


func _on_ha_true_3_words(add: Variant) -> void:
	ca_label.visible = false


func _on_ha_true_ha(str: Variant) -> void:
	ha_label.text = str(str)


func _on_ha_true_2_ha(str: Variant) -> void:
	na_label.text = str(str)


func _on_ha_true_3_ha(str: Variant) -> void:
	ca_label.text = str(str)
