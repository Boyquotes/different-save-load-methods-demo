extends Sprite2D


const SPEED := 400.0

var target := Vector2(-1, -1)


func init_json(data: Dictionary) -> void:
	position = Vector2(data.pos_x, data.pos_y)
	target = Vector2(data.target_x, data.target_y)
	modulate = Color(data.mod_r, data.mod_g, data.mod_b, 1.0)
	

func init_config_file(data: Dictionary) -> void:
	position = data.position
	target = data.target
	modulate = data.modulate
	
	
func init_custom_resource(data: ActorData) -> void:
	position = data.position
	target = data.target
	modulate = data.modulate
	
	
func _ready() -> void:
	if target.is_equal_approx(Vector2(-1, -1)):
		calculate_target()
		position = target
		modulate = Color(randf(), randf(), randf(), 1.0)


func _physics_process(delta: float) -> void:
	if target == null or position.distance_to(target) <= SPEED * delta:
		calculate_target()
	position += position.direction_to(target) * SPEED * delta


func calculate_target() -> void:
	target = Vector2(
		randf_range(0, ProjectSettings["display/window/size/viewport_width"]),
		randf_range(0, ProjectSettings["display/window/size/viewport_height"]),
	)


func serialize_json() -> Dictionary:
	return {
		"pos_x": position.x,
		"pos_y": position.y,
		"target_x": target.x,
		"target_y": target.y,
		"mod_r": modulate.r,
		"mod_g": modulate.g,
		"mod_b": modulate.b,
	}

func serialize_config_file() -> Dictionary:
	return {
		"position": position,
		"target": target,
		"modulate": modulate
	}


func serialize_custom_resource() -> ActorData:
	return ActorData.new(position, target, modulate)
