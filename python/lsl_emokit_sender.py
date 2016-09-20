# LSL broadcast Emotiv EEG raw values decrypted by emokit, based on
# https://github.com/openyou/emokit/blob/master/python/example.py

from emokit.emotiv import Emotiv
import platform
if platform.system() == "Windows":
    import socket  # Needed to prevent gevent crashing on Windows. (surfly / gevent issue #459)
import gevent
from pylsl import StreamInfo, StreamOutlet, local_clock

if __name__ == "__main__":
    headset = Emotiv(display_output=False)
    gevent.spawn(headset.setup)
    gevent.sleep(0)

    channel_names = ['AF3', 'F7', 'F3', 'FC5', 'T7', 'P7', 'O1', 'O2', 'P8', 'T8', 'FC6', 'F4', 'F8', 'AF4']

    # we pretend that our samples are actually
    # 125ms old, e.g., as if coming from some external hardware
    latency = 0.125

    # LSL Init
    info = StreamInfo('Emotiv', 'EEG', len(channel_names) * 2 + 2, 128, 'float32', 'myuid34234')
    info.desc().append_child_value("manufacturer", "Emotiv")
    channels = info.desc().append_child("channels")
    for c in channel_names:
        channels.append_child("channel") \
            .append_child_value("label", c) \
            .append_child_value("unit", "microvolts") \
            .append_child_value("type", "EEG")
    for c in channel_names:
        channels.append_child("channel") \
            .append_child_value("label", "Quality" + c) \
            .append_child_value("unit", "unitless") \
            .append_child_value("type", "Quality")
    for c in ['gyrox', 'gyroy']:
        channels.append_child("channel") \
            .append_child_value("label", c) \
            .append_child_value("unit", "unitless") \
            .append_child_value("type", "Gyroscope")

    # next make an outlet
    outlet = StreamOutlet(info, 32, 360)

    try:
        while True:
            packet = headset.dequeue()
            stamp = local_clock() - latency
            vec = []
            for c in channel_names:
                # One least-significant-bit of the fourteen-bit value you get back is 0.51 microvolts.
                vec.append(packet.sensors[c]['value'] * 0.51)
            for c in channel_names:
                vec.append(packet.sensors[c]['quality'])
            vec.extend([packet.gyro_x, packet.gyro_y])
            outlet.push_sample(vec, stamp)

            gevent.sleep(0)
    except KeyboardInterrupt:
        headset.close()
    finally:
        headset.close()
