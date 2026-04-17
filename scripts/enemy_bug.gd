extends Area2D


@export var move_direction:Vector2
@export var  move_speed:float=20
@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction

func _ready():
	# reproduce "fly" justo al aparecer en escena
	$AnimationBug.play("move")

func _physics_process(delta):
# Se mueve hacia delante, a la posición objetivo a la velocidad indicada
	global_position = global_position.move_toward(target_pos, move_speed * delta)
	# si la posición global es igual a la objetivo:
	if global_position == target_pos:
	# si la posición objetivo y la inicial son la misma:
		if target_pos == start_pos:
	# el objetivo es la posición inicial mas la dirección del movimiento
			target_pos = start_pos + move_direction
	# si no:
		else:
			# la posición objetivo y la inicial son la misma
			target_pos = start_pos
		
	
		

func _on_body_entered(body: Node2D):
	if not body.is_in_group("player"):
# regresa y hace nada
		return
# si no, imprime "Daño"
	body.take_damage(1)
