extends CanvasLayer

# contenedor de corazones
@onready var health_container = $HealthContainer
# los corazones en sí
var hearts : Array = []
# etiqueta del puntaje
@onready var score_text : Label = $ScoreText
# referencia al jugador
@onready var player = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	hearts = health_container.get_children()
	player.OnUpdateHealth.connect(_update_hearts)
	player.OnUpdateScore.connect(_update_score)
	_update_hearts(player.health)
	_update_score(PlayerStats.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# actualizar el número de corazones
func _update_hearts(health : int):
	for i in range(len(hearts)):
		hearts[i].visible = i < health

# actualizar el puntaje
func _update_score(score : int):
	score_text.text = "Score: " + str(score)
