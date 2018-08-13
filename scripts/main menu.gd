extends Node2D

var savegame = File.new()
var save_path = "user://savegame.save"
var save_data = { "highscore": 0 }

var high_score_text
var high_score_pattern = "High Score: $%s"

signal timeout

func _ready():
	high_score_text = get_node("High Score")
	if not savegame.file_exists(save_path):
		create_save()
	else:
		high_score_text.text = high_score_pattern % read_savegame()
	get_node("Start").connect("pressed", self, "_start")
	get_node("Credits").connect("pressed", self, "_credits")

func create_save():
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()

func read_savegame():
	savegame.open(save_path, File.READ) 
	save_data = savegame.get_var()
	savegame.close()
	return save_data["highscore"]

func _start():
	get_tree().change_scene("res://Main.tscn")

func _credits():
	get_tree().change_scene("res://Credits.tscn")