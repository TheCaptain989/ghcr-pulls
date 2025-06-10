#!/bin/bash
# Update the number of pulls for each package in pkg.txt
# Usage: ./update.sh
# Dependencies: curl, jq, xmllint
# From: ipitio, TheCaptain989
#
# shellcheck disable=SC2015

error_count=0
temp_file=index.tmp.json

# Check if curl, jq, and xmllint are installed
echo "::group::Checking for and installing dependencies"
if ! command -v curl &>/dev/null || ! command -v jq &>/dev/null || ! command -v xmllint &>/dev/null; then
    sudo apt-get update
    sudo apt-get install curl jq libxml2-utils -y
fi
echo "::endgroup::"

# Prepare GitHub actions summary
echo "### Pull Counts" >> $GITHUB_STEP_SUMMARY
echo "| Repository | Package| Tag | Pulls | Date |" >> $GITHUB_STEP_SUMMARY
echo "| --- | --- | --- | --- | --- |" >> $GITHUB_STEP_SUMMARY

# Update the index with new counts
while IFS= read -r line; do
    owner=$(echo "$line" | cut -d'/' -f1)
    repo=$(echo "$line" | cut -d'/' -f2)
    image=$(echo "$line" | cut -d'/' -f3)
    tag=$(echo "$line" | cut -d'/' -f4)
    json_file="./docs/$tag.json"
    # Create the index if it does not exist
    [ -f "$json_file" ] || echo "{}" >"$json_file"
    unset raw_pulls

    # Use xmllint and walk through version pages if querying tags
    if [ -n "$tag" ]; then
        # Get the number of version pages
        pages=$(curl -sSLNZ "https://github.com/$owner/$repo/pkgs/container/$image/versions" | grep -Po '(?<=data-total-pages=")\d*')
        [ -z "$pages" ] && pages=1
        # Display status (ASCII escape code for blue)
        printf "\u001b[34mCrawling $pages pages of $owner/$repo/$image for tag $tag : "
        for i in $(seq 1 "$pages"); do
            # Print the page number
            printf "$i"
            # Get the number of pulls
            raw_pulls=$(curl -sSLNZ "https://github.com/$owner/$repo/pkgs/container/$image/versions?page=$i" | xmllint --html --recover --xpath "//a[text()=\"$tag\"]/../../../div[2]/span/text()" - 2>/dev/null | tr -d '\f\n, ')
            [ -n "$raw_pulls" ] && { printf "\n"; break; }
            # Error if last page
            if [ "$i" -eq "$pages" ]; then
                # Display error message if the tag is not found
                printf "\n::error title=Missing Tag::Could not find tag %s in %s/%s/%s\n" "$tag" "$owner" "$repo" "$image"
                # Annotation already displays error message in the summary
                # printf "> [!CAUTION]\n> Could not find tag %s in %s/%s/%s\n" "$tag" "$owner" "$repo" "$image" >> $GITHUB_STEP_SUMMARY
                ((error_count++))
                continue 2
            fi
            printf ","
        done
    else
        # Get the number of pulls if not querying tags
        raw_pulls=$(curl -sSLNZ "https://github.com/$owner/$repo/pkgs/container/$image" | grep -Po '(?<=Total downloads</span>\n          <h3 title=")\d*')
        curl -sSLNZ "https://github.com/$owner/$repo/pkgs/container/$image" >temp.html
    fi
    # Display an error if the raw_pulls is empty
    if [ -z "$raw_pulls" ]; then
        printf "::error title=No Pull Counts::No raw pull counts found for %s/%s/%s\n" "$owner" "$repo" "$image"
        # Annotation already displays error message in the summary
        # printf "> [!CAUTION]\n> No raw pull counts found for %s/%s/%s\n" "$owner" "$repo" "$image" >> $GITHUB_STEP_SUMMARY
        ((error_count++))
        continue
    fi
    # Format the number of pulls
    pulls=$(numfmt --to si --round nearest --format "%f" "$raw_pulls")
    date=$(date -u +"%Y-%m-%d")
    # Display the pull counts
    printf "%s/%s/%s/%s = %s (%s) %s\n" "$owner" "$repo" "$image" "$tag" "$raw_pulls" "$pulls" "$date"
    printf "| %s/%s | %s | %s | %s (%s) | %s |\n" "$owner" "$repo" "$image" "$tag" "$raw_pulls" "$pulls" "$date" >> $GITHUB_STEP_SUMMARY

    # Update the index file
    jq --arg owner "$owner" --arg repo "$repo" --arg image "$image" --arg tag "$tag" --arg pulls "$pulls" --arg raw_pulls "$raw_pulls" --arg date "$date" '
        def days_ago(n): ($date | strptime("%Y-%m-%d")| mktime) - (n * 86400);

        if . == {} then
            {owner: $owner, repo: $repo, image: $image, tag: $tag, pulls: $pulls, raw_pulls: $raw_pulls, raw_pulls_all: {($date): $raw_pulls}}
        else
            .pulls = $pulls | .raw_pulls = $raw_pulls | .raw_pulls_all[($date)] = $raw_pulls
        end |
        .raw_pulls_all |= with_entries(
            select((.key | strptime("%Y-%m-%d") | mktime) >= days_ago(365))
        )' "$json_file" >"$temp_file"
    # Display an error if the temporary index file is empty
    if [ ! -s "$temp_file" ]; then
        printf "::error title=Empty JSON::Empty JSON file. Exiting.\n"
        # Annotation already displays error message in the summary
        # printf "> [!CAUTION]\n> Empty JSON file. Exiting.\n" >> $GITHUB_STEP_SUMMARY
        ((error_count++))
        continue
    fi
    mv "$temp_file" "$json_file"
done <pkg.txt

# Ensure temp file is gone before commit
[ -f "$temp_file" ] && rm "$temp_file"

exit $error_count
