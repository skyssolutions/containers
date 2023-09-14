#Spec: {
	app:  #NonEmptyString
	base: bool
	channels: [...#Channels]
}

#Channels: {
	name: #StringOrFloat
	platforms: [...#AcceptedPlatforms]
	debian_version?: #AcceptedDebianVersions
	stable: bool
	tests: {
		enabled: bool
		type?:   =~"^(cli|web)$"
	}
}

#StringOrFloat:           string | float & !=""
#AcceptedPlatforms:        "linux/amd64" | "linux/arm64"
#AcceptedDebianVersions:    "9" | "10" | "11" | "12"
