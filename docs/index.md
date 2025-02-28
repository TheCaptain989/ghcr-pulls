---
layout: default
---
# TheCaptain989’s GHCR Pulls
{% include navigation.html %}

## JSON Endpoint for GHCR Badges

Makes the pull count badge possible for these ghcr.io packages and tags:

[![linuxserver/docker-mods/mods/radarr-striptracks](https://img.shields.io/badge/dynamic/json?logo=github&url=https%3A%2F%2Fthecaptain989.github.io%2Fghcr-pulls%2Fradarr-striptracks.json&query=%24.pulls&label=radarr-striptracks&color=1572A4)](radarr-striptracks.json) [![linuxserver/docker-mods/mods/lidarr-flac2mp3](https://img.shields.io/badge/dynamic/json?logo=github&url=https%3A%2F%2Fthecaptain989.github.io%2Fghcr-pulls%2Flidarr-flac2mp3.json&query=%24.pulls&label=lidarr-flac2mp3&color=1572A4)](lidarr-flac2mp3.json)

### Custom Badges

The badges above are from [shields.io](https://shields.io/badges/dynamic-json-badge) and use these parameters:

#### URL from GitHub Pages

```markdown
https://thecaptain989.github.io/ghcr-pulls/<tag>.json
```

#### JSONPath

You can show either a pretty value like 12K or the raw number like 12345.

##### Pretty Count

```text
$.pulls
```

##### Raw Count

```text
$.raw_pulls
```
