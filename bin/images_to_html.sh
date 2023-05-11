#!/bin/bash
# Set the default output path to "images.html" in the current directory
output_path=${1:-"$(pwd)/images.html"}

# Set the default filter to reject hidden files and directories
default_filter="-H"

# Combine the default filter with the user filter, if provided
if [ -n "$2" ]; then
  filter="$2"
else
  filter="$default_filter"
fi

# Create an array of all image files in the current directory and its subdirectories
images=( $(fd -e jpg -e jpeg -e png -e gif -e svg $filter) )

# Set the number of columns (default: 4)
columns=${3:-4}

# Declare HTML sections as separate strings enclosed within parentheses
html_start=$(cat << HTML
<html>
<head>
<style>
:root {
  --column-count: $columns;
}
.grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(50px, 1fr));
  grid-gap: 10px;
}
.image-container img {
  width: 50px;
  height: 50px;
  object-fit: cover;
}
</style>
</head>
<body>
HTML
)

html_number_input=$(cat << HTML
<label for="column-input">Number of Columns:</label>
<input type="number" id="column-input" min="1" max="10" value="$columns"
  oninput="document.documentElement.style.setProperty('--column-count', this.value);">
HTML
)

html_grid_start="<div class=\"grid-container\">"
html_grid_end="</div>"
html_end="</body></html>"

# Concatenate the HTML content
html_content="${html_start}${html_number_input}${html_grid_start}"

# Loop through the images array and add each image to the HTML content
echo -n "Processing images"
for image in "${images[@]}"; do
    echo -n "."
    filename=$(basename "$image")
    path=$(dirname "$image")

    # Add the image to the HTML content with a fixed size container
    html_content+="<div class=\"image-container\"><img src=\"$image\"><br>$filename<br>$path</div>"
done
echo " done."

html_content+="${html_grid_end}${html_end}"

# Write the HTML content to the file
echo "$html_content" > "$output_path"
