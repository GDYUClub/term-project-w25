extends TextureButton

var point = get_meta("pointer_over_blue")

func on_Hackbar_pressed():
	while texture_normal != load("res://assets/sprites/end.png"):
		if point:
			next_level()
		else:
			restart()
	return true		
		

func next_level():
	if texture_normal == load("res://assets/sprites/stargmae.png"):
		point = get_meta("pointer_over_blue2")
		texture_normal = load("res://assets/sprites/stargmae2.png")
	elif texture_normal == load("res://assets/sprites/stargmae2.png"):
		point = get_meta("pointer_over_blue3")
		texture_normal = load("res://assets/sprites/stargmae3.png")
	elif texture_normal == load("res://assets/sprites/stargmae3.png"):
		point = get_meta("pointer_over_blue4")
		texture_normal = load("res://assets/sprites/stargmae4.png")
	else:
		texture_normal = load("res://assets/sprites/end.png")
		
func restart():
	point = get_meta("pointer_over_blue")
	texture_normal = load("res://assets/sprites/stargmae.png")
