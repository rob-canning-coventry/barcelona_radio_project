#!/usr/bin/liquidsoap

# Log dir
set("log.file.path","/tmp/barcelona-radio.log")
set("log.stdout",true)

# Sounds
#myplaylist = playlist("~/radio/playlist01.pls")

indoor_ambiences = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/indoor_ambiences")
outdoor_ambiences = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/outdoor_ambiences")
street_ambiences = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/street_ambiences")
market_ambiences = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/market_ambiences")
park_ambiences = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/park_ambiences")

# fountains, seaside, waves, drains, rain
water_sounds = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/water_sounds")

# the witching hour
the_city_sleeps = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/the_city_sleeps")

# up close detailed sounds
closeup_sounds = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/closeup_sounds")

# people - "?"
interviews_clips = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/interview_clips")

# ambiences from airport, train stations, bus journeys etc. "the next stop will be..."
transport_sounds = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/transport_sounds")

pedestrian_journeys = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/pedestrian_journeys")

other = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/other")


# Some interviews
interviews = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/interview_clips")

# If something goes wrong, we'll play this
#security = single("sounds/audiocheck.net_sweep_10Hz_10000Hz_-3dBFS_10s.wav")
security = single("sounds/error.ogg")

# Start building the feed with music
#radio = myplaylist

stereo_night = add(normalize=true,[
       security,
       park_ambiences
       ])

#    x = stereo.pan(pan=p, field=90., x)    

day=market_ambiences
night=stereo_night
daily_message = security

radio = fallback([ switch([({ 6h-18h }, 
day),({ 18h-21h05 }, night),({ 21h05-21h15 }, daily_message),({ 21h15-6h }, 
night)])])

# Now add some interviews
# radio = random(weights = [1, 4],[interviews, radio])

# And finally the security
radio = fallback(track_sensitive = false, [radio, security])
radio = mksafe(radio)





 # Stream it out
output.icecast(%mp3,
  description="Coventry University - BA Digital Media -50undz of BCN",
  genre="Experimental",
  host = "localhost", port = 8000,
  password = "hackmeCUdmvm", mount = "stream.mp3", 
  radio)

encoder_heaac_64k = %fdkaac(channels=2, samplerate=44100, bitrate=64, aot="mpeg2_he_aac_v2", transmux="adts")

output.icecast(encoder_heaac_64k,
description="Coventry University - BA Digital Media -50undz of BCN",
genre="Experimental",  
host = "localhost", port = 8000,
  password = "hackmeCUdmvm", mount = "stream.aac",
  radio)

output.icecast(%vorbis(channels=2,samplerate=44100,quality=0.5),
description="Coventry University - BA Digital Media -50undz of BCN",
genre="Experimental",
  host = "localhost", port = 8000,
  password = "hackmeCUdmvm", mount = "stream.ogg",
  radio)

output.icecast(%opus,
description="Coventry University - BA Digital Media -50undz of BCN",
genre="Experimental",
  host = "localhost", port = 8000,
  password = "hackmeCUdmvm", mount = "stream.opus",
  radio)

#utput.icecast(%mp3,radio,mount="kube",id="kubeMP3",name="KUBE Radio HIGH bandwidth",quality=8,bitrate=128,
 #                   host=kubeHost,port=kubePort,user=kubeUser,password=kubePassword,genre=kubeGenre,url=kubeUrl,description=kubeDesc)
