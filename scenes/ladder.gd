extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void: # Enables ladder climbing behavior if ladder is colliding with player
	if "Player" in body.name:
		body.on_ladder = true


func _on_body_exited(body: Node2D) -> void: # Disables ladder climbing behavior if player exists ladder collider
	if "Player" in body.name:
		body.on_ladder = false
