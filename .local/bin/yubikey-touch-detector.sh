#!/bin/bash
#
# Announces when the YubiKey is waiting for a touch, and takes the announcement
# back down the moment it isn't.
#
# The Linux yubikey-touch-detector daemon does not port: its GPG detector waits
# for inotify IN_OPEN events on the files under ~/.gnupg, and FSEvents has no
# notion of a file being opened. What that daemon does once triggered is
# portable, though, and is what happens below. gpg-agent serialises access to
# the card, so a trivial question that does not come back means the card is
# busy: either pinentry is collecting the PIN or the key is waiting to be
# touched. Measured on this machine, an idle probe answers in 30ms and one
# issued across a touch prompt blocked for 8.2 seconds.
#
# A probe reaches the card, so probing is confined to the moment a new gpg or
# ssh process shows up. Nothing touches the card while the machine is idle.

set -u

PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin

# Deliberately not $TMPDIR: the daemon runs under launchd and the sketchybar
# plugin runs under sketchybar, and the two are not guaranteed the same one.
STATE_FILE=/tmp/yubikey-touch.state

# Processes whose arrival is worth a probe. Written as an alternation because
# BSD pgrep -x is unreliable with a bare name.
CONSUMERS='gpg|gpgsm|ssh|ssh-add|ssh-keygen'
PINENTRIES='pinentry|pinentry-mac'

TICK=0.1          # seconds per wait tick while a probe is outstanding
BLOCKED_TICKS=4   # ticks an unanswered probe earns before it counts as blocked
ABANDON_TICKS=600 # ticks before a probe is written off as wedged
BURST_SECONDS=20  # how long to keep probing after a consumer appears
IDLE_GAP=0.4      # seconds between probes once the card answers promptly

reasons() {
  local reasons=""
  pgrep -x 'gpg|gpgsm' >/dev/null 2>&1 && reasons="GPG"
  pgrep -x 'ssh|ssh-add|ssh-keygen' >/dev/null 2>&1 && reasons="${reasons:+$reasons }SSH"
  printf '%s' "${reasons:-GPG}"
}

# The banner is a one-shot ping and the sketchybar pill is the live state, a
# split forced by what macOS 26 will actually deliver. Anything that can withdraw
# a notification has to go through UserNotifications, which refuses to authorise
# an app that lacks a real signing identity -- an ad-hoc signature is rejected
# with "Notifications are not allowed for this application", and a freshly minted
# bundle identifier is rejected the same way, so it is the signature and not a
# remembered denial. osascript posts under Script Editor's own authorisation,
# which works, but exposes no way to take a notification back down. Hence: the
# banner announces, self-dismisses on the usual timer, and leaves a line in
# Notification Center; the pill is what actually tracks whether the key is still
# waiting.
announce() {
  [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "$1" ] && return
  printf '%s' "$1" >"$STATE_FILE"
  osascript -e "display notification \"Waiting for a touch ($1)\" with title \"YubiKey\"" \
    >/dev/null 2>&1
  sketchybar --trigger yubikey_touch >/dev/null 2>&1
}

withdraw() {
  [ -f "$STATE_FILE" ] || return
  rm -f "$STATE_FILE"
  sketchybar --trigger yubikey_touch >/dev/null 2>&1
}

# Asks the agent for the card serial and times the answer. Returns 0 if the card
# answered promptly, 1 if it was busy. A PIN prompt blocks the probe exactly as
# a touch prompt does, so pinentry is checked on every tick rather than once:
# a card unlock is a PIN prompt that turns into a touch prompt partway through.
probe() {
  gpg-connect-agent --no-autostart 'SCD SERIALNO' /bye >/dev/null 2>&1 &
  local probe_pid=$! ticks=0

  while kill -0 "$probe_pid" 2>/dev/null; do
    ticks=$((ticks + 1))
    if [ "$ticks" -ge "$ABANDON_TICKS" ]; then
      kill "$probe_pid" 2>/dev/null
      break
    fi
    if [ "$ticks" -ge "$BLOCKED_TICKS" ]; then
      if pgrep -x "$PINENTRIES" >/dev/null 2>&1; then
        withdraw
      else
        announce "$(reasons)"
      fi
    fi
    sleep "$TICK"
  done

  wait "$probe_pid" 2>/dev/null
  withdraw
  [ "$ticks" -lt "$BLOCKED_TICKS" ]
}

# A single operation can need more than one touch (sign, then decrypt), so a
# blocked probe is followed immediately by another with no gap.
burst() {
  local deadline=$((SECONDS + BURST_SECONDS))
  while [ "$SECONDS" -lt "$deadline" ]; do
    probe || continue
    pgrep -x "$CONSUMERS" >/dev/null 2>&1 || return
    sleep "$IDLE_GAP"
  done
}

trap 'withdraw; exit 0' TERM INT

withdraw
seen=""
while :; do
  pids=$(pgrep -x "$CONSUMERS" 2>/dev/null | tr '\n' ' ')
  arrived=0
  for pid in $pids; do
    case " $seen " in
    *" $pid "*) ;;
    *) arrived=1 ;;
    esac
  done
  seen=$pids

  [ "$arrived" -eq 1 ] && burst
  sleep 0.25
done
