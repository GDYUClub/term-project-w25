extends Area2D

func _on_body_entered(body: Node2D) -> void: # Enables ladder climbing behavior if ladder is colliding with player
	if body.is_in_group("player"):
		body.on_ladder = true


func _on_body_exited(body: Node2D) -> void: # Disables ladder climbing behavior if player exists ladder collider
	if body.is_in_group("player"):
		body.on_ladder = false
