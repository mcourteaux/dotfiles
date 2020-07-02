ffmpeg_compress() {
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    filename="${filename%.*}"

    ffmpeg -i "$filename" -c:v libx264 -crf $2 -pix_fmt yuv420p "$filename.small.mp4"
}

ffmpeg_compress_width() {
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    filename="${filename%.*}"

    ffmpeg -i "$filename" -c:v libx264 -crf $2 -pix_fmt yuv420p -filter "scale=$3:-2" "$filename.small.mp4"
}
