ffmpeg_compress() {
    filename=$(basename -- "$1")
    filename="${filename%.*}"

    ffmpeg -i "$1" -c:v libx264 -crf $2 -profile:v baseline -preset slower -pix_fmt yuv420p "$filename.small.mp4"
}

ffmpeg_compress_width() {
    filename=$(basename -- "$1")
    filename="${filename%.*}"

    ffmpeg -i "$1" -c:v libx264 -crf $2 -profile:v baseline -preset slower -pix_fmt yuv420p -filter "scale=$3:-2" "$filename.small.mp4"
}

ffmpeg_compress_nv() {
    filename=$(basename -- "$1")
    filename="${filename%.*}"

    ffmpeg -i "$1" -c:v h264_nvenc -crf $2 -profile:v baseline -preset slow -pix_fmt yuv420p "$filename.small_nvenc.mp4"
}

ffmpeg_compress_width() {
    filename=$(basename -- "$1")
    filename="${filename%.*}"

    ffmpeg -i "$1" -c:v h264_nvenc -crf $2 -profile:v baseline -preset slow -pix_fmt yuv420p -filter:v "scale=$3:-2" "$filename.small_nvenc.mp4"
}

ffmpeg_hevc_nvenc() {
    filename=$(basename -- "$1")
    filename="${filename%.*}"

    ffmpeg -strict 2 -hwaccel auto  -i "$1" \
            -c:v hevc_nvenc -rc vbr -cq 27 -qmin 14 -qmax 34 \
            -profile:v main -pix_fmt yuv420p \
            -b:v 0K -c:a aac -map 0 \
            "${filename}.nvenc.h265.mp4"
}

ffmpeg_hevc_nvenc_lq() {
    filename=$(basename -- "$1")
    filename="${filename%.*}"

    ffmpeg -strict 2 -hwaccel auto  -i "$1" \
            -filter:v "scale=800:-2" \
            -c:v hevc_nvenc -rc vbr -cq 35 -qmin 14 -qmax 34 \
            -profile:v main -pix_fmt yuv420p \
            -b:v 0K -c:a aac -map 0 \
            "${filename}.nvenc.h265.lq.mp4"
}
