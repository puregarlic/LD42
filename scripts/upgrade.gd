extends Node2D

var costs = [4, 8, 12, 16, 20]
var costIndex = 0
var costFormat = "$%s"
var costLabel
var button

signal upgrade
signal score

func _ready():
	costLabel = get_node("Cost")
	costLabel.text = costFormat % costs[costIndex]
	button = get_node("Button")
	get_node("../Bed").connect('score', self, "_enable")
	get_node("../Bed").connect('upgrade', self, "_upgrade")
	button.connect('pressed', self, "_disable")

func _enable(score):
	if score >= costs[costIndex]:
		costLabel.hide()
		button.disabled = false
	else:
		costLabel.show()
		button.disabled = true

func _disable():
	costLabel.show()
	button.disabled = true

func _upgrade():
	costIndex += 1
	costLabel.text = costFormat % costs[costIndex]
