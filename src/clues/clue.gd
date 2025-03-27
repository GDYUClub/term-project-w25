extends Resource
class_name Clue

enum Type {NORMAL, MERGING, DOCUMENT}
@export var type : Type = Type.NORMAL;
@export var mergeResultant : Clue;
@export var documentSprite : Texture;
@export var id:int
@export var lvl_id:int
@export var name:String 
@export var desc:String 
@export var icon:Texture
@export var panel:Texture
@export var environment_sprite:Texture
@export var picks_up:bool
@export var correct_panel:int

func _to_string() -> String:
	return name
