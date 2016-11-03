# Plot incoming LSL data, based on
# https://github.com/sccn/labstreaminglayer/blob/master/LSL/liblsl-Python/examples/ReceiveDataInChunks.py

from pylsl import StreamInlet, resolve_stream
import matplotlib.pyplot as plt
import numpy as np

# first resolve an EEG stream on the lab network
print("looking for an EEG stream...")
streams = resolve_stream('type', 'EEG')

# create a new inlet to read from the stream
inlet = StreamInlet(streams[0])
info = inlet.info()
print("number of channels: %d" % info.channel_count())

buf = np.zeros((128 * 2, info.channel_count()))

while True:
    # get a new sample (you can also omit the timestamp part if you're not
    # interested in it)
    chunk, timestamps = inlet.pull_chunk()
    if timestamps:
        for vec in chunk:
            buf = np.append(buf, np.matrix(vec), axis=0)
        buf = buf[-128 * 2:, :]
        plt.clf()
        for i in range(0, info.channel_count()):
            offset = i * 10
            plt.plot(buf[:, i] - np.mean(buf[:, i] + offset))
        plt.pause(0.01)
