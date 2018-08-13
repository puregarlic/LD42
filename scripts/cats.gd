extends Node2D

onready var cat1 = preload("res://scenes/cat1.tscn")
onready var cat2 = preload("res://scenes/cat2.tscn")
onready var cat3 = preload("res://scenes/cat3.tscn")
onready var cat4 = preload("res://scenes/cat4.tscn")
var cats = []

signal spawn_cat
signal cats_updated

func _ready():
	cats.push_back(cat1)
	cats.push_back(cat2)
	cats.push_back(cat3)
	cats.push_back(cat4)
	_spawn_cat()
	get_node("../Bed").connect('spawn_cat', self, '_spawn_cat')

func _spawn_cat():
	var roll = randi() % 4
	var cat = cats[roll].instance()
	cat.position = to_local(position)
	add_child(cat)
	emit_signal('cats_updated')
	pass
