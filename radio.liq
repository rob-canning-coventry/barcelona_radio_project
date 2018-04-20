#!/usr/bin/liquidsoap
# Log dir
set("log.file.path","/tmp/basic-radio.log")

# Music
myplaylist = playlist("~/radio/playlist01.pls")
# Some jingles
#jingles = playlist("~/radio/jingles.m3u")
# If something goes wrong, we'll play this
security = single("~/radio/sounds/barcelona_test.wav")

# Start building the feed with music
radio = myplaylist
# Now add some jingles
#radio = random(weights = [1, 4],[jingles, radio])
# And finally the security
radio = fallback(track_sensitive = false, [radio, security])
radio=mksafe(radio)

 # Stream it out

output.icecast(%mp3,
  description="Coventry University - BA Digital Media -50undz of BCN",
  genre="Experimental",
  host = "localhost", port = 8000,
  password = "*****", mount = "stream.mp3", 
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
