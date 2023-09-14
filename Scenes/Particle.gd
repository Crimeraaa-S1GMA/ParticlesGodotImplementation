extends Sprite

class_name Particle

var x : int = 0
var y : int = 0

func _ready():
	randomize()

func _process(delta):
	if position.distance_to(get_global_mouse_position()) < 1.2:
		modulate = Color.white
		if Input.is_action_pressed("place_particle"):
			if Input.is_action_pressed("space"):
				get_tree().current_scene.particle_indexes[x][y] = ParticleTileData.new(100, -1, 0, 0)
			else:
				match randi() % 4:
					0:
						get_tree().current_scene.particle_indexes[x][y] = ParticleTileData.new(1, -1, 0, 1)
					1:
						get_tree().current_scene.particle_indexes[x][y] = ParticleTileData.new(2, -1, 1, 0)
					2:
						get_tree().current_scene.particle_indexes[x][y] = ParticleTileData.new(3, -1, 0, 0)
					3:
						get_tree().current_scene.particle_indexes[x][y] = ParticleTileData.new(5, -1, 1, 0)
	else:
		match get_tree().current_scene.particle_indexes[x][y].particle_id:
			1:
				modulate = Color.red
			2:
				modulate = Color.yellow
			3:
				modulate = Color.green
			5:
				modulate = Color.purple
			4:
				modulate = Color.blue
			100:
				modulate = Color.white
			0:
				modulate = Color.black
