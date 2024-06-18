# ghcr.io pulls

## JSON Endpoint for GHCR Badges

Makes the pull count badge possible for these ghcr.io packages:

[![linuxserver/docker-mods/mods/radarr-striptracks](https://img.shields.io/badge/dynamic/json?logo=github&url=https%3A%2F%2Fraw.githubusercontent.com%2Fthecaptain989%2Fghcr-pulls%2Fmaster%2Findex.json&query=%24%5B%3F(%40.owner%3D%3D%22linuxserver%22%20%26%26%20%40.repo%3D%3D%22docker-mods%22%20%26%26%20%40.image%3D%3D%22mods%22%20%26%26%20%40.tag%3D%3D%22radarr-striptracks%22)%5D.pulls&label=mods/radarr-striptracks)](https://github.com/linuxserver/docker-mods/pkgs/container/mods) [![linuxserver/docker-mods/mods/lidarr-flac2mp3](https://img.shields.io/badge/dynamic/json?logo=github&url=https%3A%2F%2Fraw.githubusercontent.com%2Fthecaptain989%2Fghcr-pulls%2Fmaster%2Findex.json&query=%24%5B%3F(%40.owner%3D%3D%22linuxserver%22%20%26%26%20%40.repo%3D%3D%22docker-mods%22%20%26%26%20%40.image%3D%3D%22mods%22%20%26%26%20%40.tag%3D%3D%22lidarr-flac2mp3%22)%5D.pulls&label=mods/lidarr-flac2mp3)](https://github.com/linuxserver/docker-mods/pkgs/container/mods)

### Custom Badges

The badge above are from [shields.io](https://shields.io/badges/dynamic-json-badge) and use these parameters:

#### URL

```markdown
https://raw.githubusercontent.com/thecaptain989/ghcr-pulls/master/index.json
```

#### JSONPath

You can show either a pretty value like 12K or the raw number like 12345.

##### Pretty Count

```markdown
$[?(@.owner=="<USER>" && @.repo=="<REPO>" && @.image=="<IMAGE>")].pulls
```

##### Raw Count

```markdown
$[?(@.owner=="<USER>" && @.repo=="<REPO>" && @.image=="<IMAGE>")].raw_pulls
```

