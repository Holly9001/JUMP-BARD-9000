extends Area3D

@export var target:Node

func _on_body_entered(body):
	if body.get_class() == "CharacterBody3D":
		target.trigger()
