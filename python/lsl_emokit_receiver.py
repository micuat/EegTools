# Plot incoming LSL data, based on
# https://github.com/sccn/labstreaminglayer/blob/master/LSL/liblsl-Python/examples/ReceiveDataInChunks.py

from pylsl import StreamInlet, resolve_stream
import matplotlib.pyplot as plt

# first resolve an EEG stream on the lab network
print("looking for an EEG stream...")
streams = resolve_stream('type', 'EEG')

# create a new inlet to read from the stream
inlet = StreamInlet(streams[0])

buf = [0] * 128 * 5

while True:
    # get a new sample (you can also omit the timestamp part if you're not
    # interested in it)
    chunk, timestamps = inlet.pull_chunk()
    if timestamps:
        for vec in chunk:
            buf.append(vec[0])
        buf = buf[-128 * 5:]
        plt.clf()
        plt.plot(buf)
        plt.pause(0.05)
