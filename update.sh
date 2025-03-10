#!/bin/bash
# Update the number of pulls for each package in pkg.txt
# Usage: ./update.sh
# Dependencies: curl, jq
# From: ipitio, TheCaptain989
#
# shellcheck disable=SC2015

error_count=0

# check if curl, jq, and xmllint are installed
echo "::group::Checking for and installing dependencies"
if ! command -v curl &>/dev/null || ! command -v jq &>/dev/null || ! command -v xmllint &>/dev/null; then
    sudo apt-get update
    sudo apt-get install curl jq libxml2-utils -y
fi
echo "::endgroup::"

# Prepare GitHub acctions summary
echo "### Pull Counts" >> $GITHUB_STEP_SUMMARY
echo "| Repository | Package| Tag | Pulls | Date |" >> $GITHUB_STEP_SUMMARY
echo "| --- | --- | --- | --- | --- |" >> $GITHUB_STEP_SUMMARY

# update the index with new counts
while IFS= read -r line; do
    owner=$(echo "$line" | cut -d'/' -f1)
    repo=$(echo "$line" | cut -d'/' -f2)
    image=$(echo "$line" | cut -d'/' -f3)
    tag=$(echo "$line" | cut -d'/' -f4)
    json_file="./docs/$tag.json"
    [ -f "$json_file" ] || echo "{}" >"$json_file" # create the index if it does not exist
    unset raw_pulls

    # use xmllint and walk through version pages if querying tags
    if [ -n "$tag" ]; then
        pages=$(curl -sSLNZ "https://github.com/$owner/$repo/pkgs/container/$image/versions" | grep -Po '(?<=data-total-pages=")\d*')
        [ -z "$pages" ] && pages=1
        # Testing if the error prints correctly
        printf "\n::error title=Unknown Tag::Could not find tag %s in %s/%s/%s\n" "$tag" "$owner" "$repo" "$image"
        printf "\u001b[34mCrawling $pages pages of $owner/$repo/$image for tag $tag : "
        for i in $(seq 1 "$pages"); do
            raw_pulls=$(curl -sSLNZ "https://github.com/$owner/$repo/pkgs/container/$image/versions?page=$i" | xmllint --html --recover --xpath "//a[text()=\"$tag\"]/../../../div[2]/span/text()" - 2>/dev/null | tr -d '\f\n, ')
            printf "$i"
            [ -n "$raw_pulls" ] && break
            [ "$i" -ne "$pages" ] && printf "," || { printf "\n::error title=Unknown Tag::Could not find tag %s in %s/%s/%s\n" "$tag" "$owner" "$repo" "$image"; printf "*ERROR:* Could not find tag %s in %s/%s/%s\n" "$tag" "$owner" "$repo" "$image" >> $GITHUB_STEP_SUMMARY; ((error_count++)); continue 2; }
        done
        printf "\n"
    else
        # get the number of pulls,
        raw_pulls=$(curl -sSLNZ "https://github.com/$owner/$repo/pkgs/container/$image" | grep -Po '(?<=Total downloads</span>\n          <h3 title=")\d*')
        curl -sSLNZ "https://github.com/$owner/$repo/pkgs/container/$image" >temp.html
    fi
    [ -z "$raw_pulls" ] && { printf "::error title=No Pull Counts::No raw pull counts found for %s/%s/%s\n" "$owner" "$repo" "$image"; printf "*ERROR:* No raw pull counts found for %s/%s/%s\n" "$owner" "$repo" "$image" >> $GITHUB_STEP_SUMMARY; ((error_count++)); continue; }
    pulls=$(numfmt --to si --round nearest --format "%f" "$raw_pulls")
    date=$(date -u +"%Y-%m-%d")
    printf "%s/%s/%s/%s = %s (%s) %s\n" "$owner" "$repo" "$image" "$tag" "$raw_pulls" "$pulls" "$date"
    printf "| %s/%s | %s | %s | %s (%s) | %s |\n" "$owner" "$repo" "$image" "$tag" "$raw_pulls" "$pulls" "$date" >> $GITHUB_STEP_SUMMARY

    jq --arg owner "$owner" --arg repo "$repo" --arg image "$image" --arg tag "$tag" --arg pulls "$pulls" --arg raw_pulls "$raw_pulls" --arg date "$date" '
        if . == {} then
            {owner: $owner, repo: $repo, image: $image, tag: $tag, pulls: $pulls, raw_pulls: $raw_pulls, raw_pulls_all: {($date): $raw_pulls}}
        else
            .pulls = $pulls | .raw_pulls = $raw_pulls | .raw_pulls_all[($date)] = $raw_pulls
        end' "$json_file" >index.tmp.json
    [ -s index.tmp.json ] && mv index.tmp.json "$json_file" || { printf "ERROR: Empty JSON file. Exiting.\n"; printf "*ERROR:* Empty JSON file. Exiting.\n" >> $GITHUB_STEP_SUMMARY; exit 1; }
done <pkg.txt

# # sort the index by the number of raw_pulls greatest to smallest
# jq 'sort_by(.raw_pulls | tonumber) | reverse' "$json_file" >index.tmp.json
# mv index.tmp.json "$json_file"

exit $error_count
