extends Node2D


const SAVE_PATH_JSON := "user://save.json"
const SAVE_PATH_CONFIG_FILE := "user://save.ini"
const SAVE_PATH_CUSTOM_RESOURCE := "user://save_custom_resource.res"
const SAVE_PATH_PACKED_SCENE := "user://save_packed_scene.scn"

@export var Actor: PackedScene
@export var num_actors := 1_000


func _ready() -> void:
	for i in num_actors:
		var actor := Actor.instantiate()
		$Actors.add_child(actor)
		actor.owner = $Actors
	$UILayer/UI/LoadJSON.disabled = not FileAccess.file_exists(SAVE_PATH_JSON)
	$UILayer/UI/LoadConfigFile.disabled = not FileAccess.file_exists(SAVE_PATH_CONFIG_FILE)
	$UILayer/UI/LoadCustomResource.disabled = not FileAccess.file_exists(SAVE_PATH_CUSTOM_RESOURCE)
	$UILayer/UI/LoadPackedScene.disabled = not FileAccess.file_exists(SAVE_PATH_PACKED_SCENE)


func clear_actors() -> void:
	for actor in get_tree().get_nodes_in_group("actors"):
		actor.free()


func show_time_taken(start_time: float) -> void:
	$UILayer/Notification.text = "%s ms taken" % (Time.get_ticks_msec() - start_time)
	$UILayer/Notification/AnimationPlayer.play("fade")


func _on_save_json_pressed() -> void:
	var start_time := Time.get_ticks_msec()
	var file := FileAccess.open(SAVE_PATH_JSON, FileAccess.WRITE)
	for actor in get_tree().get_nodes_in_group("actors"):
		file.store_line(JSON.stringify(actor.serialize_json()))
	file.close()
	$UILayer/UI/LoadJSON.disabled = false
	show_time_taken(start_time)


func _on_load_json_pressed() -> void:
	if not FileAccess.file_exists(SAVE_PATH_JSON):
		$UILayer/UI/LoadJSON.disabled = true
		return
	var start_time := Time.get_ticks_msec()
	clear_actors()
	var file := FileAccess.open(SAVE_PATH_JSON, FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line()
		if not line == "":
			var actor := Actor.instantiate()
			actor.init_json(JSON.parse_string(line))
			$Actors.add_child(actor)
			actor.owner = $Actors
	file.close()
	show_time_taken(start_time)


func _on_save_config_file_pressed() -> void:
	var start_time := Time.get_ticks_msec()
	var config_file := ConfigFile.new()
	for actor in get_tree().get_nodes_in_group("actors"):
		config_file.set_value("actors", actor.name, actor.serialize_config_file())
	config_file.save(SAVE_PATH_CONFIG_FILE)
	$UILayer/UI/LoadConfigFile.disabled = false
	show_time_taken(start_time)


func _on_load_config_file_pressed() -> void:
	if not FileAccess.file_exists(SAVE_PATH_CONFIG_FILE):
		$UILayer/UI/LoadConfigFile.disabled = true
		return
	var start_time := Time.get_ticks_msec()
	clear_actors()
	var config_file := ConfigFile.new()
	config_file.load(SAVE_PATH_CONFIG_FILE)
	for key in config_file.get_section_keys("actors"):
		var actor := Actor.instantiate()
		actor.init_config_file(config_file.get_value("actors", key))
		$Actors.add_child(actor)
		actor.owner = $Actors
	show_time_taken(start_time)


func _on_save_custom_resource_pressed() -> void:
	var start_time := Time.get_ticks_msec()
	var actor_data: Array[ActorData] = []
	for actor in get_tree().get_nodes_in_group("actors"):
		actor_data.append(actor.serialize_custom_resource())
	var save_resource := SaveResource.new(actor_data)
	ResourceSaver.save(save_resource, SAVE_PATH_CUSTOM_RESOURCE)
	$UILayer/UI/LoadCustomResource.disabled = false
	show_time_taken(start_time)


func _on_load_custom_resource_pressed() -> void:
	if not FileAccess.file_exists(SAVE_PATH_CUSTOM_RESOURCE):
		$UILayer/UI/LoadCustomResource.disabled = true
		return
	var start_time := Time.get_ticks_msec()
	clear_actors()
	var save_resource := ResourceLoader.load(SAVE_PATH_CUSTOM_RESOURCE, "SaveResource")
	for actor_data in save_resource.actor_data:
		var actor := Actor.instantiate()
		actor.init_custom_resource(actor_data)
		$Actors.add_child(actor)
		actor.owner = $Actors
	show_time_taken(start_time)


func _on_save_packed_scene_pressed() -> void:
	var start_time := Time.get_ticks_msec()
	var scene := PackedScene.new()
	scene.pack($Actors)
	ResourceSaver.save(scene, SAVE_PATH_PACKED_SCENE)
	$UILayer/UI/LoadPackedScene.disabled = false
	show_time_taken(start_time)


func _on_load_packed_scene_pressed() -> void:
	if not FileAccess.file_exists(SAVE_PATH_PACKED_SCENE):
		$UILayer/UI/LoadPackedScene.disabled = true
		return
	var start_time := Time.get_ticks_msec()
	$Actors.free()
	var scene := ResourceLoader.load(SAVE_PATH_PACKED_SCENE, "PackedScene")
	add_child(scene.instantiate())
	show_time_taken(start_time)


func _on_clear_pressed() -> void:
	DirAccess.remove_absolute(SAVE_PATH_JSON)
	DirAccess.remove_absolute(SAVE_PATH_CONFIG_FILE)
	DirAccess.remove_absolute(SAVE_PATH_CUSTOM_RESOURCE)
	DirAccess.remove_absolute(SAVE_PATH_PACKED_SCENE)
	$UILayer/UI/LoadJSON.disabled = true
	$UILayer/UI/LoadConfigFile.disabled = true
	$UILayer/UI/LoadCustomResource.disabled = true
	$UILayer/UI/LoadPackedScene.disabled = true
