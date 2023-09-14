#!/usr/bin/env python3

import os
import sys
import json
import subprocess


def main():
    FETCH_ALL = False
    if "all" in sys.argv:
        FETCH_ALL = True

    app_channel_dict = {}

    for root, dirs, files in os.walk('./apps'):
        for file in files:
            if file == 'metadata.json':
                with open(os.path.join(root, file), 'r') as f:
                    metadata = json.load(f)
                    app = metadata.get('app')
                    channels = metadata.get('channels', [])

                    channel_list = []
                    for channel_info in channels:
                        channel_name = str(channel_info.get('name'))
                        stable = channel_info.get('stable')

                        if FETCH_ALL:
                            channel_list.append(channel_name)
                        else:
                            published_version = subprocess.run(
                                ["./.github/scripts/published.sh", app, channel_name, str(stable)], text=True,
                                capture_output=True).stdout.strip()
                            upstream_version = subprocess.run(
                                ["./.github/scripts/upstream.sh", app, channel_name, str(stable)], text=True,
                                capture_output=True).stdout.strip()

                            if published_version != upstream_version and upstream_version not in ["", "null"]:
                                print(
                                    f"{app}{'-' + channel_name if stable == False else ''}:{published_version if published_version else '<NOTFOUND>'} -> {upstream_version}")
                                channel_list.append(channel_name)

                    if channel_list:
                        app_channel_dict[app] = channel_list

    output = []
    for app, channels in app_channel_dict.items():
        for channel in channels:
            output.append({"app": app, "channel": channel})

    output_json = json.dumps(output, indent=4)

    with open(os.getenv('GITHUB_OUTPUT'), 'a') as f:
        f.write(f"changes={output_json}")


if __name__ == "__main__":
    main()
