extends Area2D

# escena que cargará al tocar la bandera
@export var scene_to_load : PackedScene



func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Players"):
		return
	call_deferred("_load_new_scene")
	
func _load_new_scene ():
	get_tree().change_scene_to_packed(scene_to_load)
