#!/usr/bin/env python3
import sys
import json


def main(app, channels):
    if app == "ALL":
        # Call your existing fetch.py script here if needed
        pass
    else:
        channels_list = channels.split(',')
        images_array = [{"app": app, "channel": channel} for channel in channels_list]

        print(json.dumps(images_array, indent=None))


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
