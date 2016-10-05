# LSL broadcast Muse EEG stream

from OSC import OSCServer, OSCClient, OSCMessage
from pylsl import StreamInfo, StreamOutlet, local_clock
import time

if __name__ == "__main__":
    def eeg_callback(path, tags, args, source):
        stamp = args[4] + args[5] * 0.001 * 0.001 - latency
        outlet.push_sample(args[0:4], stamp)
    def default_callback(path, tags, args, source):
        # do nothing
        return

    # get very naive time offset
    latency = time.time() - local_clock()
    print latency

    # muse-io server
    server = OSCServer( ("localhost", 12000) )
    server.timeout = 0
    server.addMsgHandler( "/muse/eeg", eeg_callback )
    server.addMsgHandler( "default", default_callback )

    channel_names = ['TP9', 'Fp1', 'Fp2', 'TP10'] #, 'DRL', 'REF']

    # LSL Init
    info = StreamInfo('Muse', 'EEG', len(channel_names), 220, 'float32', 'myuid34234')
    info.desc().append_child_value("manufacturer", "Interaxon")
    channels = info.desc().append_child("channels")
    for c in channel_names:
        channels.append_child("channel") \
            .append_child_value("label", c) \
            .append_child_value("unit", "microvolts") \
            .append_child_value("type", "EEG")

    # next make an outlet
    outlet = StreamOutlet(info, 32, 360)

    def each_frame():
        # clear timed_out flag
        server.timed_out = False
        # handle all pending requests then return
        while not server.timed_out:
            server.handle_request()

    try:
        while True:
            time.sleep(0.001)
            each_frame()
    except KeyboardInterrupt:
        server.close()
    finally:
        server.close()
