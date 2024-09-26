# TheCaptain989's GHCR Pulls

## JSON Endpoint for GHCR Badges

Makes the pull count badge possible for these ghcr.io packages and tags:

[![linuxserver/docker-mods/mods/radarr-striptracks](https://img.shields.io/badge/dynamic/json?logo=github&url=https%3A%2F%2Fthecaptain989.github.io%2Fghcr-pulls%2Fradarr-striptracks.json&query=%24.pulls&label=mods/radarr-striptracks&color=1572A4)](https://github.com/linuxserver/docker-mods/tree/radarr-striptracks) [![linuxserver/docker-mods/mods/lidarr-flac2mp3](https://img.shields.io/badge/dynamic/json?logo=github&url=https%3A%2F%2Fthecaptain989.github.io%2Fghcr-pulls%2Flidarr-flac2mp3.json&query=%24.pulls&label=mods/lidarr-flac2mp3&color=1572A4)](https://github.com/linuxserver/docker-mods/tree/lidarr-flac2mp3)

### Custom Badges

The badges above are from [shields.io](https://shields.io/badges/dynamic-json-badge) and use these parameters:

#### URL from GitHub Pages

```markdown
https://thecaptain989.github.io/ghcr-pulls/radarr-striptracks.json
```

#### JSONPath

You can show either a pretty value like 12K or the raw number like 12345.

##### Pretty Count

```http
$.pulls
```

##### Raw Count

```http
$.raw_pulls
```
