extends StaticBody2D

var savegame = File.new()	
var save_path = "user://savegame.save"
var save_data = { "highscore": 0 }

var timer
var beds = []
var bedIndex = 0
var scoreLabel
var score = 0
var scoreFormat = '$%s'

signal timeout
signal main_placed
signal scoring
signal spawn_cat
signal game_over
signal score
signal pressed
signal upgrade

func _ready():
	beds.push_back(get_node("Bed 1"))
	beds.push_back(get_node("Bed 2"))
	beds.push_back(get_node("Bed 3"))
	beds.push_back(get_node("Bed 4"))
	beds.push_back(get_node("Bed 5"))

	scoreLabel = get_node('../Score/Text')
	timer = get_node("Timer")
	timer.connect('timeout', self, '_next_round')
	get_node("../Cats").connect('cats_updated', self, '_connect_cats')
	get_node("../Upgrade/Button").connect("pressed", self, "_upgrade")

func _process(delta):
	if Input.is_action_pressed("escape"):
		get_tree().change_scene("res://Menu.tscn")

func _connect_cats():
	for node in get_tree().get_nodes_in_group("Cats"):
		node.connect('game_over', self, '_game_over')
		node.connect('main_placed', self, '_start_timer')
		node.connect('scoring', self, '_tally')

func _game_over():
	if read_savegame() < score:
		save(score)
	get_tree().reload_current_scene()

func _start_timer():
	timer.start()

func _next_round():
	score = 0
	get_tree().call_group("Cats", "send_score")
	emit_signal('spawn_cat')
	
func _tally():
	score += 1
	_update_score()
	
func _update_score():
	scoreLabel.text = scoreFormat % score
	emit_signal('score', score)

func _upgrade():
	_disable_bed(bedIndex)
	bedIndex += 1
	_enable_bed(bedIndex)
	emit_signal('upgrade')

	if bedIndex == 4:
		get_node("../Upgrade").hide()

func _enable_bed(index):
	beds[index].disabled = false
	beds[index].show()

func _disable_bed(index):
	beds[index].disabled = true
	beds[index].hide()

func save(score):
	print('Saved')
	save_data["highscore"] = score
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()

func read_savegame():
	savegame.open(save_path, File.READ)
	save_data = savegame.get_var()
	savegame.close()
	return save_data["highscore"]