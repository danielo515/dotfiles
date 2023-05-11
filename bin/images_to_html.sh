#!/bin/bash
# Set the default output path to "images.html" in the current directory
output_path=${1:-"$(pwd)/images.html"}

# Set the default filter to reject hidden files and directories
default_filter="-not -path '*/.*'"

# Combine the default filter with the user filter, if provided
if [ -n "$2" ]; then
  filter="-not -path '$2'"
else
  filter="$default_filter"
fi

# Create an array of all image files in the current directory and its subdirectories
images=( $(find . -type f -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" $filter) )

# Start the HTML file
echo "<html><body><table>" > "$output_path"

# Set the number of images to display per row
images_per_row=4

# Loop through the images array and add each image to the HTML file
echo -n "Processing images"
for (( i=0; i<${#images[@]}; i+=images_per_row )); do
    echo -n "."
    echo "<tr>" >> "$output_path"
    for (( j=0; j<$images_per_row; j++ )); do
        # Get the filename and absolute path for the current image
        index=$((i+j))
        if [[ $index -lt ${#images[@]} ]]; then
            image="${images[$index]}"
            filename=$(basename "$image")
            path=$(cd "$(dirname "$image")"; pwd)

            # Add the image to the HTML file
            echo "<td><img src=\"$path/$filename\"><br>$filename<br>$path</td>" >> "$output_path"
        fi
    done
    echo "</tr>" >> "$output_path"
done
echo " done."

# End the HTML file
echo "</table></body></html>" >> "$output_path"
