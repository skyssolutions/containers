import os
import sys
import json


def main(added_or_modified_images, debian_version):
    changes_array = []

    for app in added_or_modified_images:
        with open(f"./apps/{app}/metadata.json") as f:
            metadata = json.load(f)

        for channel in metadata.get('channels', []):
            change = {
                "app": app,
                "channel": channel.get('name'),
                "debian_version": debian_version
            }
            changes_array.append(change)

    print(json.dumps(changes_array))


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
