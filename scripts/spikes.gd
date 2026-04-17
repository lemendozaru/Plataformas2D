extends Area2D

func _on_body_entered(body: Node2D):
	if not body.is_in_group("player"):
# regresa y hace nada
		return
# si no imprime "Daño"
	body.take_damage(5)
	

# Called when the node enters the scene tree for the first time.
