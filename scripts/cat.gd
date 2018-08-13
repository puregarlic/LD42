extends RigidBody2D

var is_picked = false
var mouse_drag_speed = 20
var moved = false
var main = true
var meowTimer

var pitch
var pickup
var meow
var loss

signal game_over
signal main_placed
signal spawn_cat
signal send_score
signal scoring
signal finished

func _ready():
	pitch = randf() * 2
	var enter = get_node("Sounds/Enter")
	pickup = get_node("Sounds/Pickup")
	meow = get_node("Sounds/Meow")
	loss = get_node("Sounds/Loss")

	enter.pitch_scale = pitch
	pickup.pitch_scale = pitch
	meow.pitch_scale = pitch
	loss.pitch_scale = pitch

	enter.play()

	meowTimer = get_node("Timer")
	meowTimer.connect("timeout", self, "_meow")
	loss.connect('finished', self, "_game_over")

func _input_event( viewport, event, shape_idx ):
	if _event_is_left_button(event) and event.pressed:
		is_picked = true
		pickup.play()
		if not moved:
			set_collision_mask_bit(2, false)
			moved = true
		if main:
			emit_signal('main_placed')
			main = false

func _input(event):
	if _event_is_left_button(event) and not event.pressed:
		is_picked = false

func _event_is_left_button(event):
	return event is InputEventMouseButton and event.button_index == BUTTON_LEFT    

func _physics_process(delta):
	if is_picked:
		linear_velocity = get_global_mouse_position() - global_position
		linear_velocity *= mouse_drag_speed

func _process(delta):
	for contact in get_colliding_bodies():
		if contact.get_name() == 'Boundaries':
			if not loss.playing:
				loss.play()

func send_score():
	emit_signal('scoring')

func _meow():
	var amount = (randi() % 12) + 4
	meowTimer.wait_time = amount
	meowTimer.start()
	meow.play()

func _game_over():
	emit_signal("game_over")