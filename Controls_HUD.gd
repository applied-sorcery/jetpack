extends ReferenceRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var controls_display = get_node("../ControlsLink")

	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ControlsLink_pressed():
	self.visible = !self.visible
