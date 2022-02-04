#!/bin/bash

monitors_json=$(aerospace list-monitors --json)
monitor_count=$(echo "$monitors_json" | jq length)

if [ "$monitor_count" -eq 2 ]; then
  aerospace move-workspace-to-monitor --workspace 1 1
  aerospace move-workspace-to-monitor --workspace 2 1
  aerospace move-workspace-to-monitor --workspace 3 1
  aerospace move-workspace-to-monitor --workspace 4 1
  aerospace move-workspace-to-monitor --workspace 5 1
  aerospace move-workspace-to-monitor --workspace 6 2
  aerospace move-workspace-to-monitor --workspace 7 2
  aerospace move-workspace-to-monitor --workspace 8 2
  aerospace move-workspace-to-monitor --workspace 9 2
  aerospace move-workspace-to-monitor --workspace 10 2
elif [ "$monitor_count" -eq 3 ]; then
  aerospace move-workspace-to-monitor --workspace 1 1
  aerospace move-workspace-to-monitor --workspace 2 1
  aerospace move-workspace-to-monitor --workspace 3 1
  aerospace move-workspace-to-monitor --workspace 4 2
  aerospace move-workspace-to-monitor --workspace 5 2
  aerospace move-workspace-to-monitor --workspace 6 2
  aerospace move-workspace-to-monitor --workspace 7 2
  aerospace move-workspace-to-monitor --workspace 8 3
  aerospace move-workspace-to-monitor --workspace 9 3
  aerospace move-workspace-to-monitor --workspace 10 3
fi
