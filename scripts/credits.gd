extends Node2D

func _ready():
	get_node("Back").connect("pressed", self, "_back")

func _back():
	get_tree().change_scene("res://Menu.tscn")
