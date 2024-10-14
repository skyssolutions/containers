#Spec: {
    app: #AppName
    semver?: bool
    build_disabled?: bool
    channels: [...#Channels]
}

#Channels: {
    name: #ChannelName
    platforms: [...#Platforms]
    stable: bool
    tests: {
        enabled: bool
        type?:   =~"^(cli|web)$"
    }
}

#AppName:     string & !="" & =~"^[a-zA-Z0-9_-]+$"
#ChannelName: string & !="" & =~"^[a-zA-Z0-9._-]+$"
#Platforms:   "linux/amd64" | "linux/arm64"