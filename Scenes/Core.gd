extends Node2D

onready var particle : PackedScene = preload("res://Scenes/Particle.tscn")

var particle_indexes : Array = []

var sim_frame : int = 0

var sim_size : Vector2 = Vector2(100, 100)

func _ready():
	randomize()
	
	var noise : OpenSimplexNoise = OpenSimplexNoise.new()
	
	noise.seed = randi()
	
	noise.period = 0.5
	
	for y in range(sim_size.y):
		var x_arr : Array = []
		for x in range(sim_size.x):
			if y == 0 or y == sim_size.y - 1 or x == 0 or x == sim_size.x - 1:
				x_arr.append(ParticleTileData.new(100))
			else:
				var amount : float = noise.get_noise_2d(x, y)
				if amount > 0.2:
					if amount > 0.45:
						x_arr.append(ParticleTileData.new(1, -1, 0, -1))
					elif amount > 0.35:
						x_arr.append(ParticleTileData.new(2, -1, 0, 1))
					elif amount > 0.3:
						x_arr.append(ParticleTileData.new(5, -1, -1, 0))
					elif amount > 0.25:
						x_arr.append(ParticleTileData.new(3, -1, 0, 0))
					else:
						x_arr.append(ParticleTileData.new(4, -1, 0, 0))
				else:
					x_arr.append(ParticleTileData.new(0, -1, 0, 0))
			var particle_ins : Particle = particle.instance()
			
			particle_ins.x = x
			particle_ins.y = y
			
			particle_ins.position = (Vector2(x, y) * 2) + Vector2.ONE * 8
			
			add_child(particle_ins)
		particle_indexes.append(x_arr.duplicate())

func process_particles() -> void:
	for y in range(sim_size.y):
		for x in range(sim_size.x):
			if particle_indexes[x][y].last_frame_updated != sim_frame:
				match particle_indexes[x][y].particle_id:
					1:
						if particle_indexes[x][y + particle_indexes[x][y].direction_y].particle_id == 0:
							particle_indexes[x][y + particle_indexes[x][y].direction_y] = ParticleTileData.new(1, sim_frame, particle_indexes[x][y].direction_x, particle_indexes[x][y].direction_y)
							particle_indexes[x][y] = ParticleTileData.new(0, sim_frame)
						else:
							particle_indexes[x][y].direction_y *= -1
							if particle_indexes[x + particle_indexes[x][y].direction_x * -1][y + particle_indexes[x][y].direction_y * -1].particle_id == 4:
								if particle_indexes[x + particle_indexes[x][y].direction_x * -2][y + particle_indexes[x][y].direction_y * -2].particle_id == 0:
									particle_indexes[x + particle_indexes[x][y].direction_x * -1][y + particle_indexes[x][y].direction_y * -1] = ParticleTileData.new(0, sim_frame)
									particle_indexes[x + particle_indexes[x][y].direction_x * -2][y + particle_indexes[x][y].direction_y * -2] = ParticleTileData.new(4, sim_frame)
					2:
						if particle_indexes[x + particle_indexes[x][y].direction_x][y + particle_indexes[x][y].direction_y].particle_id == 0:
							particle_indexes[x + particle_indexes[x][y].direction_x][y + particle_indexes[x][y].direction_y] = ParticleTileData.new(2, sim_frame, particle_indexes[x][y].direction_x, particle_indexes[x][y].direction_y)
							particle_indexes[x][y] = ParticleTileData.new(0, sim_frame)
						else:
							match Vector2(particle_indexes[x][y].direction_x, particle_indexes[x][y].direction_y):
								Vector2.RIGHT:
									particle_indexes[x][y].direction_x = 0
									particle_indexes[x][y].direction_y = 1
								Vector2.DOWN:
									particle_indexes[x][y].direction_x = -1
									particle_indexes[x][y].direction_y = 0
								Vector2.LEFT:
									particle_indexes[x][y].direction_x = 0
									particle_indexes[x][y].direction_y = -1
								Vector2.UP:
									particle_indexes[x][y].direction_x = 1
									particle_indexes[x][y].direction_y = 0
							if particle_indexes[x + particle_indexes[x][y].direction_x * -1][y + particle_indexes[x][y].direction_y * -1].particle_id == 4:
								if particle_indexes[x + particle_indexes[x][y].direction_x * -2][y + particle_indexes[x][y].direction_y * -2].particle_id == 0:
									particle_indexes[x + particle_indexes[x][y].direction_x * -1][y + particle_indexes[x][y].direction_y * -1] = ParticleTileData.new(0, sim_frame)
									particle_indexes[x + particle_indexes[x][y].direction_x * -2][y + particle_indexes[x][y].direction_y * -2] = ParticleTileData.new(4, sim_frame)
					3:
						var dir : Vector2 = Vector2.ZERO
						match randi() % 8:
							0:
								dir = Vector2(1, 0)
							1:
								dir = Vector2(-1, 0)
							2:
								dir = Vector2(0, 1)
							3:
								dir = Vector2(0, -1)
							4:
								dir = Vector2(1, 1)
							5:
								dir = Vector2(-1, 1)
							6:
								dir = Vector2(-1, -1)
							7:
								dir = Vector2(1, -1)
						if particle_indexes[x + dir.x][y + dir.y].particle_id == 0:
							particle_indexes[x + dir.x][y + dir.y] = ParticleTileData.new(3, sim_frame, particle_indexes[x][y].direction_x, particle_indexes[x][y].direction_y)
							particle_indexes[x][y] = ParticleTileData.new(0, sim_frame)
						else:
							if particle_indexes[x + particle_indexes[x][y].direction_x * -1][y + particle_indexes[x][y].direction_y * -1].particle_id == 4:
								if particle_indexes[x + particle_indexes[x][y].direction_x * -2][y + particle_indexes[x][y].direction_y * -2].particle_id == 0:
									particle_indexes[x + particle_indexes[x][y].direction_x * -1][y + particle_indexes[x][y].direction_y * -1] = ParticleTileData.new(0, sim_frame)
									particle_indexes[x + particle_indexes[x][y].direction_x * -2][y + particle_indexes[x][y].direction_y * -2] = ParticleTileData.new(4, sim_frame)
					4:
						if randi() % 850 == 0:
							var x_rand : int = (randi() % (int(sim_size.x) - 2)) + 1
							var y_rand : int = (randi() % (int(sim_size.y) - 2)) + 1
							
							particle_indexes[x_rand][y_rand] = ParticleTileData.new(4, sim_frame)
							particle_indexes[x][y] = ParticleTileData.new(0, sim_frame)
					5:
						if particle_indexes[x + particle_indexes[x][y].direction_x][y].particle_id == 0:
							particle_indexes[x + particle_indexes[x][y].direction_x][y] = ParticleTileData.new(5, sim_frame, particle_indexes[x][y].direction_x, particle_indexes[x][y].direction_y)
							particle_indexes[x][y] = ParticleTileData.new(0, sim_frame)
						else:
							particle_indexes[x][y].direction_x *= -1
							if particle_indexes[x + particle_indexes[x][y].direction_x * -1][y + particle_indexes[x][y].direction_y * -1].particle_id == 4:
								if particle_indexes[x + particle_indexes[x][y].direction_x * -2][y + particle_indexes[x][y].direction_y * -2].particle_id == 0:
									particle_indexes[x + particle_indexes[x][y].direction_x * -1][y + particle_indexes[x][y].direction_y * -1] = ParticleTileData.new(0, sim_frame)
									particle_indexes[x + particle_indexes[x][y].direction_x * -2][y + particle_indexes[x][y].direction_y * -2] = ParticleTileData.new(4, sim_frame)
	sim_frame += 1

func _on_ProcessingTimer_timeout():
	process_particles()
