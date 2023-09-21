extends Node

func get_children_of_type(in_node, type, arr:=[]):
	if in_node.get_class() == type:
		arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_children_of_type(child, type, arr)
	return arr
