class_name DockedState extends State

onready var attacker = get_node("../../Attacker")

var boid
var base
var target

func get_class():
	return "DockedState"

func _enter():
	boid = get_parent()
	base = get_node("../../Base")
	target = base.global_transform.origin
	boid.get_node("Seek").world_target = target
	boid.get_node("Seek").set_enabled(true)
	pass
	
func _think():
	var to_attacker = boid.global_transform.origin.distance_to(attacker.global_transform.origin)
	if to_attacker < 300:
		boid.get_node("StateMachine").change_state(LaunchState.new())

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
