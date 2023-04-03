class_name School extends Node

export var fish_scene:PackedScene

export var count = 5

export var radius = 100

export var neighbor_distance = 20
export var max_neighbors = 10

var boids = []

export var cell_size = 10
export var grid_size = 10000
export var partition = true
var cells = {}

func draw_gizmos():
	if partition:
		var size = 100
		var sub_divisions = size / cell_size
		var half = sub_divisions / 2
		for slice in range (- half, half + 1):
			var p = Vector3(0, 0, slice * cell_size)
			DebugDraw.draw_grid(p, Vector3.UP * size, Vector3.RIGHT * size, Vector2(sub_divisions, sub_divisions), Color.aquamarine, true)
			p = Vector3(0, slice * cell_size, 0)
			# DebugDraw.draw_grid(p, Vector3.FORWARD * size, Vector3.RIGHT * size, Vector2(sub_divisions, sub_divisions), Color.aquamarine)

func position_to_cell(pos): 
	pos += Vector3(10000, 10000, 10000)       
	return floor(pos.x / cell_size) + (floor(pos.y / cell_size) * grid_size) + (floor(pos.z / cell_size) * grid_size * grid_size)
	# return 0
	
func cell_to_position(cell):
	var z = floor(cell / (grid_size * grid_size)
	var y = floor((cell - (z * grid_size * grid_size)) / grid_size)
	var x = cell - (y * grid_size + (z * grid_size * grid_size)) 
	
	var p = Vector3(x, y, z) * cell_size
	p -= Vector3(10000, 10000, 10000) 
	return p
	
func partition():
	cells.clear()	
	for boid in boids:
		var key = position_to_cell(boid.transform.origin)
		if ! cells.has(key):
			cells[key] = []	
		cells[key].push_back(boid)

func _process(delta):
	if partition:
		partition()
	draw_gizmos()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in count:
		var fish = fish_scene.instance()		
		add_child(fish)
		var pos = Utils.random_point_in_unit_sphere() * radius
		fish.global_transform.origin = pos
		fish.global_transform.basis = Basis(Vector3.UP, rand_range(0, PI * 2.0))
		
		var boid
		if fish is Boid:
			boid = fish
		else:
			boid = fish.find_node("Boid", true)
		if boids.size() == 0:
			boid.draw_gizmos = true
		boids.push_back(boid)		
		
		var constrain = boid.get_node("Constrain")
		if constrain:
			constrain.center = $"../Center"	
			constrain.radius = radius
