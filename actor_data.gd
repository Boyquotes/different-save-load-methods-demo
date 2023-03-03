extends Resource
class_name ActorData


# Must be exported to be saved with ResourceSaver.
@export var position: Vector2
@export var target: Vector2
@export var modulate: Color


# Must have default parameters or else Godot will error.
func _init(p := Vector2(-1, -1), t := Vector2(-1, -1), m := Color.WHITE) -> void:
	position = p
	target = t
	modulate = m
