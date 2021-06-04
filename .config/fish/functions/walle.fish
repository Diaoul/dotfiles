function walle -d 'Your wallpaper manager robot'
    set base ~/wallpapers
    switch $argv[1]
        case 'unsplash'
            set resolution (
                xrandr | grep primary | awk -F '[ +]' '{print $4}'
            )
            echo -n "Setting wallpaper from unsplash with resolution $resolution..."
            curl -sL https://source.unsplash.com/random/$resolution \
                -o $base/random.jpg
            feh --bg-fill $base/random.jpg
            echo ' Done!'
        case 'save'
            set uuid (
                string split - -m 1 (bat /proc/sys/kernel/random/uuid) \
                | head -n 1
            )
            cp $base/random.jpg $base/$uuid.jpg
            echo "Wallpaper saved to $uuid.jpg"
        case 'random'
            set file (exa -I random.jpg $base | shuf -n 1)
            feh --bg-fill $base/$file
            echo "Wallpaper set to $file"
        case '*'
            echo "Unknown command '$argv[1]'"
            echo '  Possible values: (unsplash|save|random)'
    end
end
