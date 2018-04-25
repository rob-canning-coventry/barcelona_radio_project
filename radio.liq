#!/home/COVENTRY.AC.UK/ac2131/.opam/system/bin/liquidsoap

PASSWORD=argv(1)

# Log dir
set("log.file.path","/tmp/barcelona-radio.log")
set("log.stdout",true)

# Sounds
contemplative_spaces1 = playlist(mode='randomize',reload=1,reload_mode="rounds", "sounds/contemplative_spaces")
contemplative_spaces2 = playlist(mode='normal', "sounds/contemplative_spaces")

# If something goes wrong, we'll play this
security = single("sounds/error.ogg")

# Start building the feed with music

# radio_mixer: A little function that accepts pan location delay ammount and feedback as arguments

def radio_mixer(p, d, f, s)
        x = echo(s, delay=d, feedback=f )
	x = stereo.pan(pan=p, field=90., x)
	x
	end

# this bit gives different audio playlist streams a different position
# in the stereo field and delay parameters
a = radio_mixer(-0.8, 4.0, -9., contemplative_spaces1)
b = radio_mixer( 0.8, 3.7, -9., contemplative_spaces2)
# -----------------
# this bit adds all the different audio streams together in a montage
# you can add as many as you like a, b, c, d, etc. - 
out = add(normalize=true,[
       a,
       b
       ])
# -----------------
# this adds some reverb to the overall mix
# to find more about the parameters of these ladspa effects
# liquidsoap -h ladspa.zita_reverb
out = ladspa.zita_reverb(out)
# -----------------

day=out
night=out
daily_message = security

# -----------------

# This is the scheduling - i.e. which sound montage to play when
# at the moment we only have one called "out" - but we need to come up with many more!
day=out
night=out
daily_message=security

radio = fallback([ switch([
({ 6h-18h }, day),
({ 18h-21h05 }, night),
({ 21h05-21h15 }, daily_message),
({ 21h15-6h }, night)])
])

# -----------------
# Now add some interviews
# radio = random(weights = [1, 4],[interviews, radio])
# -----------------
# And finally the security
radio = fallback(track_sensitive = false, [radio, security])
radio = mksafe(radio)
# -----------------
# Everything below here is for sending the stream to icecast server which makes the
# internet radio mountpoints found here: http://dmvm.coventry.ac.uk:8000
# to listen to the stream you can point your browser or media player to:
# http://dmvm.coventry.ac.uk:8000/stream.aac


def stream (c,m,o)
    # stream: a function to create mountpoints
    out = output.icecast(c,
    host="localhost", port=8000,
    description="Coventry University - BA Digital Media -50undz of BCN",
    genre="Network Music",url="http://aslkfjslkfjslkfjslkfj.net",
    password="#{PASSWORD}",
    mount = m, fallible=true, icy_metadata="true", o)
    out
end

# Stream it out  #############################

stream(%mp3,   "stream.mp3", radio)
stream(%vorbis,"stream.ogg", radio)
stream(%opus,"stream.opus", radio)
encoder_heaac_64k = %fdkaac(channels=2, samplerate=44100, bitrate=64, aot="mpeg2_he_aac_v2", transmux="adts")
stream(encoder_heaac_64k,   "stream.aac", radio)

#  password = "hackmeCUdmvm", mount = "stream.opus",

