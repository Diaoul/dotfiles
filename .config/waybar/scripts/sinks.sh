#!/usr/bin/env fish
set pwdump (pw-dump)

# list all audio sinks, excluding some
set blacklist (pactl -f json list sinks | jq -r '.[] | select(.ports[] | .availability == "not available") | .name')
set ids (
    echo $pwdump | \
    jq -r '
        sort_by(.info.props."node.nick") |
        .[] |
        select(.info.props."node.name" | IN(
            "'(string join '","' $blacklist)'"
        ) | not) |
        select(.info.props."media.class" == "Audio/Sink") |
        .id'
)

# get currently active sink
set active_name (pactl get-default-sink)
set active_id (echo $pwdump | jq -r ".[] | select(.info.props.\"media.class\" == \"Audio/Sink\") | select(.info.props.\"node.name\" == \"$active_name\") | .id")


function next_sink_index
    if not contains $active_id $ids; or test (contains -i $active_id $ids) -eq (count $ids)
        echo 1
    else
        echo (math (contains -i $active_id $ids) + 1)
    end
end

function previous_sink_index
    if not contains $active_id $ids; or test (contains -i $active_id $ids) -eq 1
        echo -1
    else
        echo (math (contains -i $active_id $ids) - 1)
    end
end

function debug
    echo Blacklist:
    for item in $blacklist
        echo " - $item"
    end
    echo All ids: $ids
    echo Active sink:
    print_sink $active_id
    echo Next sink:
    print_sink $ids[(next_sink_index)]
end

function print_sink
    set id $argv[1]
    set nick (echo $pwdump | jq ".[] | select(.id == $id) | .info.props.\"node.nick\"")
    set name (echo $pwdump | jq ".[] | select(.id == $id) | .info.props.\"node.name\"")
    set desc (echo $pwdump | jq ".[] | select(.id == $id) | .info.props.\"node.description\"")
    echo "  Id: $id"
    echo "  Nick: $nick"
    echo "  Name: $name"
    echo "  Description: $desc"
end


function cli_help
    set cli_name (status --current-filename)
    echo "
$cli_name
Sinks switcher
Usage: $cli_name [command]
Commands:
  next     Switch to next sink
  previous Switch to previous sink
  debug    Debug
  *        Help
"
    exit 1
end

switch $argv[1]
    case next
        wpctl set-default $ids[(next_sink_index)]
    case previous
        wpctl set-default $ids[(previous_sink_index)]
    case debug
        debug
    case '*'
        cli_help
end
