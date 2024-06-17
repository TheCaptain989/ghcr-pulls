# ghcr.io pulls

## JSON Endpoint for GHCR Badges

Makes the pull count badge possible for these ghcr.io packages:

[![linuxserver/docker-mods/mods/](https://img.shields.io/badge/dynamic/json?logo=github&url=https%3A%2F%2Fraw.githubusercontent.com%2Fthecaptain989%2Fghcr-pulls%2Fmaster%2Findex.json&query=%24%5B%3F(%40.owner%3D%3D%22linuxserver%22%20%26%26%20%40.repo%3D%3D%22docker-mods%22%20%26%26%20%40.image%3D%3D%22mods%22)%5D.pulls&label=mods%22%20%26%26%20%40.tag%3D%3D%22$tag%22)](https://github.com/linuxserver/docker-mods/pkgs/container/mods) [![linuxserver/docker-mods/mods/radarr-striptracks](https://img.shields.io/badge/dynamic/json?logo=github&url=https%3A%2F%2Fraw.githubusercontent.com%2Fthecaptain989%2Fghcr-pulls%2Fmaster%2Findex.json&query=%24%5B%3F(%40.owner%3D%3D%22linuxserver%22%20%26%26%20%40.repo%3D%3D%22docker-mods%22%20%26%26%20%40.image%3D%3D%22mods%22%20%26%26%20%40.tag%3D%3D%22radarr-striptracks%22)%5D.pulls&label=mods/radarr-striptracks)](https://github.com/linuxserver/docker-mods/pkgs/container/mods) [![linuxserver/docker-mods/mods/lidarr-flac2mp3](https://img.shields.io/badge/dynamic/json?logo=github&url=https%3A%2F%2Fraw.githubusercontent.com%2Fthecaptain989%2Fghcr-pulls%2Fmaster%2Findex.json&query=%24%5B%3F(%40.owner%3D%3D%22linuxserver%22%20%26%26%20%40.repo%3D%3D%22docker-mods%22%20%26%26%20%40.image%3D%3D%22mods%22%20%26%26%20%40.tag%3D%3D%22lidarr-flac2mp3%22)%5D.pulls&label=mods/lidarr-flac2mp3)](https://github.com/linuxserver/docker-mods/pkgs/container/mods)

If we don't yet follow an image, you can either:

* open an issue or
* add it on a new line in `pkg.txt` on your own fork [here](https://github.com/ipitio/ghcr-pulls/edit/master/pkg.txt) and make a pull request.

### Custom Badges

To make a badge, you can modify one of the badges above or generate one with something like [shields.io](https://shields.io/badges/dynamic-json-badge) and these parameters:

#### URL

```markdown
https://raw.githubusercontent.com/ipitio/ghcr-pulls/master/index.json
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

### Further Study

GHCR itself doesn't provide an API endpoint for the pull count, so Github Packages is scraped twice daily for every image in `pkg.txt`. In addition to the latest stats, the index also contains a history of the raw pull counts for each image, starting on 2024-06-10, should you find that useful or interesting. Should the pulls for each tag be kept individually as well?

### TODO

Feel free to help with any of these:

* [ ] Make a GitHub Pages site that integrates ghcr-pulls with [eggplants/ghcr-badge](https://github.com/eggplants/ghcr-badge) (or provides an alternative)
* [ ] Show each version:

```json
{
    ...,
    "version": {
        "<version>": {
            "raw_pulls": "365",
            "raw_pulls_day": "1",
            "raw_pulls_week": "7",
            "raw_pulls_month": "30",
            "raw_pulls_all": {
                "<date>": "365"
            }
        }
    }
}
```

* [ ] Any other improvements or ideas you have
