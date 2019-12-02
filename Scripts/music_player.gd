extends AudioStreamPlayer

signal song_changed

const music_options = {
	"pretending_to_make":preload("res://Audio/Music/pretending_to_converse.ogg")
}

const song_metadata = {
	"pretending_to_make":["Alex", "Pretending To Make Conversation", "0:00"]
}

var ingame_songs = ["pretending_to_make"]
var target_song = ""
var fading = false
var popped = false
var dummy_player
var music_bus

func _ready():
	music_bus = AudioServer.get_bus_index("music")
	#AudioServer.set_bus_volume_db(music_bus, -60 + 60*data.get_value("Options", "music_volume", 100)/100)
	stream = music_options["pretending_to_make"]
	bus = "music"
	play()
	
	dummy_player = AudioStreamPlayer.new()
	dummy_player.bus = "music"
	add_child(dummy_player)
	
	#mute()
	
func _process(delta):
	if(fading):
		dummy_player.volume_db += delta*60
		volume_db -= delta*60
		
		if(dummy_player.volume_db >= 0):
			dummy_player.volume_db = 0
			fading = false
			stream = music_options[target_song]
			play(dummy_player.get_playback_position())
			dummy_player.stop()
			volume_db = 0
			popped = false

	if(get_playback_position() >= stream.get_length() - 0.5 and not(popped)):
		play_new_ingame_song()
		popped = true
	
func play_song(song):
	target_song = song
	fading = true
	dummy_player.stream = music_options[song]
	dummy_player.volume_db = -60
	dummy_player.play()
	
#	var music_popup = RESOURCES.music_popup.instance()
#	music_popup.artist_name = song_metadata[song][0]
#	music_popup.song_name = song_metadata[song][1]
#	music_popup.song_length = song_metadata[song][2]
#	add_child(music_popup)
	
func set_decimal_volume(volume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("colony_music"), -60 + 60*volume/100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("web_music"), -60 + 60*volume/100)
#	data.set_value("Options", "music_volume", volume)
#	data.save()
	
func get_decimal_volume():
	return ((AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus))/60)+1)*100

func init_ingame_music():
	connect("finished", self, "play_new_ingame_song")
	play_new_ingame_song()
	
func play_new_ingame_song():
	var song = ingame_songs[randi()%ingame_songs.size()]
	
	play_song(song)
	
func set_target_bus(bus_name: String):
	bus = bus_name
	dummy_player.bus = bus_name
	
func mute():
	set_decimal_volume(0)
	
func unmute():
	set_decimal_volume(100)