extends Node

@onready var hud: CenterContainer = $CenterContainer


var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()


func _on_host_pressed() -> void:
	peer.create_server(3500, 2)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	_on_peer_connected()
	hud.hide()

func _on_join_pressed() -> void:
	var ip = $CenterContainer/VBoxContainer/IPInput.text.strip_edges()
	var port = 3500
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	hud.hide()

func _on_peer_connected(id: int = 1):
	var player_scene = load("res://Scenes/Players/ARCH.tscn")
	var player_instance = player_scene.instantiate()
	player_instance.name = str(id)
	add_child(player_instance, true)
