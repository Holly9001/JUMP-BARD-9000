extends Area3D

@export var target:Node

func _on_body_entered(body):
	target.enabled = true
