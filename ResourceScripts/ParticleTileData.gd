extends Resource

class_name ParticleTileData

var particle_id : int = 0

var direction_x : int = 0
var direction_y : int = 0

var last_frame_updated : int = -1

func _init(particle_id : int = 0, last_frame_updated : int = -1, direction_x : int = 0, direction_y : int = 0):
	self.particle_id = particle_id
	self.last_frame_updated = last_frame_updated
	
	self.direction_x = direction_x
	self.direction_y = direction_y
