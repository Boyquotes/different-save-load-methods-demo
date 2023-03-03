extends Resource
class_name SaveResource


# Must be exported to be saved with ResourceSaver.
@export var actor_data: Array[ActorData]


# Must have default parameters or else Godot will error.
func _init(a: Array[ActorData] = []) -> void:
	actor_data = a
