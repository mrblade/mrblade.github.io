#!/bin/bash

# Directory for generated HTML files
HTML_DIR="./pages"

# Create the directory if it does not exist
mkdir -p "$HTML_DIR"

# Remove all existing HTML files except 404
find "$HTML_DIR" -maxdepth 1 -name '*.html' ! -name '404.html' -exec rm -f {} +

# Read the list of links and titles from fighost.json
jq -c '.[]' fighost.json | while read -r item; do
  link=$(echo "$item" | jq -r '.link')
  title=$(echo "$item" | jq -r '.title')
  
  # Sanitize the title to create a filename
  filename=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '-' | tr -d '[:punct:]').html

  # Generate the HTML file
  cat <<EOF > "$HTML_DIR/$filename"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$title</title>
</head>
<body>
    <iframe src="$link" width="100%" height="100%" frameborder="0"></iframe>
</body>
</html>
EOF
  # Print the filename of the generated HTML file
  echo "Generated file: $HTML_DIR/$filename"
done