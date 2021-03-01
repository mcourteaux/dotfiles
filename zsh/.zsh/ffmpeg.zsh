ffmpeg_compress() {
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    filename="${filename%.*}"

    ffmpeg -i "$1" -c:v libx264 -crf $2 -profile:v baseline -preset slower -pix_fmt yuv420p "$filename.small.mp4"
}

ffmpeg_compress_width() {
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    filename="${filename%.*}"

    ffmpeg -i "$1" -c:v libx264 -crf $2 -profile:v baseline -preset slower -pix_fmt yuv420p -filter "scale=$3:-2" "$filename.small.mp4"
}

ffmpeg_compress_nv() {
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    filename="${filename%.*}"

    ffmpeg -i "$1" -c:v h264_nvenc -crf $2 -profile:v baseline -preset slow -pix_fmt yuv420p "$filename.small_nvenc.mp4"
}

ffmpeg_compress_width() {
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    filename="${filename%.*}"

    ffmpeg -i "$1" -c:v h264_nvenc -crf $2 -profile:v baseline -preset slow -pix_fmt yuv420p -filter "scale=$3:-2" "$filename.small_nvenc.mp4"
}
