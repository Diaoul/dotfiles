#!/usr/bin/env bash
# Workspace event handling.
#
# Every branch resyncs the whole workspace strip in a single sketchybar call.
# That is what makes windows opening or closing on a workspace you are not
# looking at show up, and it also covers the `forced` sender that sketchybar
# emits on --update / --reload, which used to be dropped on the floor.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/utils/aerospace.sh"

case "$SENDER" in
  aerospace_workspace_change)
    sb_log "focusing $FOCUSED_WORKSPACE from $PREV_WORKSPACE"
    ;;
  space_windows_change | forced)
    sb_log "resync on $SENDER"
    ;;
  *)
    sb_log "unknown event $SENDER"
    exit 0
    ;;
esac

sync_workspaces
