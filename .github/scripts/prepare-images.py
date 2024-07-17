#!/usr/bin/env python3

import sys

import json
import subprocess

from datetime import datetime, timezone
from os.path import isfile


def get_upstream_version(app, channel):
    latest_py = f"./apps/{app}/ci/latest.py"
    latest_sh = f"./apps/{app}/ci/latest.sh"
    latest_channel_py = f"./apps/{app}/{channel}/ci/latest.py"
    latest_channel_sh = f"./apps/{app}/{channel}/ci/latest.sh"

    if isfile(latest_channel_py):
        args = ["python3", latest_channel_py, channel]
    elif isfile(latest_channel_sh):
        args = ["bash", latest_channel_sh, channel]
    elif isfile(latest_py):
        args = ["python3", latest_py, channel]
    elif isfile(latest_sh):
        args = ["bash", latest_sh, channel]
    else:
        return ""

    output = subprocess.check_output(args)
    return output.decode("utf-8").strip()


if __name__ == "__main__":
    changed_apps = json.loads(sys.argv[1])
    forRelease = sys.argv[2] == "true"

    out = {"manifestsToBuild": [], "imagePlatformPermutations": []}

    for app in changed_apps:
        name = app["app"]
        channel = str(app["channel"])

        with open(f"./apps/{name}/metadata.json") as f:
            metadata = json.load(f)

        try:
            if metadata['build_disabled']:
                continue
        except KeyError:
            pass

        # Generate Config
        cfg = {}
        for ch in metadata["channels"]:
            if str(ch["name"]) == channel:
                cfg = ch
                break
            else:
                cfg = ch
                break

        app["chan_build_date"] = datetime.now(timezone.utc).isoformat()
        app["chan_stable"] = cfg["stable"]
        app["chan_tests_enabled"] = cfg["tests"]["enabled"]
        app["chan_tests_type"] = cfg["tests"]["type"]
        app["chan_upstream_version"] = get_upstream_version(name, channel)

        if app["chan_tests_enabled"] and app["chan_tests_type"] == "cli":
            app["chan_goss_args"] = "tail -f /dev/null"

        if app.get("base", False):
            app["chan_label_type"] = "org.opencontainers.image.base"
        else:
            app["chan_label_type"] = "org.opencontainers.image"

        if isfile(f"./apps/{name}/{channel}/Dockerfile"):
            app["chan_dockerfile"] = f"./apps/{name}/{channel}/Dockerfile"
            app["chan_goss_config"] = f"./apps/{name}/{channel}/goss.yaml"
        else:
            app["chan_dockerfile"] = f"./apps/{name}/Dockerfile"
            app["chan_goss_config"] = f"./apps/{name}/ci/goss.yaml"

        if app["chan_stable"]:
            app["chan_image_name"] = name
            app["chan_tag_rolling"] = f"{name}:rolling"
            if app['chan_upstream_version'] == "":
                pass
            else:
                app["chan_tag_version"] = f"{name}:{app['chan_upstream_version']}"
            app["chan_tag_testing"] = f"{name}:testing"
        else:
            app["chan_image_name"] = f"{name}-{channel}"
            app["chan_tag_rolling"] = f"{name}-{channel}:rolling"
            if app['chan_upstream_version'] == "":
                pass
            else:
                app["chan_tag_version"] = f"{name}-{channel}:{app['chan_upstream_version']}"
            app["chan_tag_testing"] = f"{name}-{channel}:testing"
        try:
            if cfg["debian_version"] != "null":
                app["chan_debian_version"] = cfg["debian_version"]
        except KeyError:
            pass

        for platform in cfg["platforms"]:
            if platform != "linux/amd64" and not forRelease:
                continue
            to_append = app.copy()
            to_append["platform"] = platform
            if platform == "linux/amd64":
                to_append["builder"] = "buildjet-2vcpu-ubuntu-2204"
            elif platform == "linux/arm64":
                to_append["builder"] = "buildjet-2vcpu-ubuntu-2204-arm"
            if platform != "linux/amd64":
                to_append["chan_tests_enabled"] = False
            out["imagePlatformPermutations"].append(to_append)

            main_manifest = {
                "image": app["chan_image_name"],
                "app": name,
                "channel": channel,
                "platforms": cfg["platforms"],
                "version": app["chan_upstream_version"],
            }
        try:
            manifest_tags_with_version = {
                "tags": [app["chan_tag_rolling"], app["chan_tag_version"]],
            }
            main_manifest.update(manifest_tags_with_version)
        except KeyError:
            manifest_tags = {
                "tags": [app["chan_tag_rolling"]]
            }
            main_manifest.update(manifest_tags)
        out["manifestsToBuild"].append(main_manifest)

    print(json.dumps(out))
