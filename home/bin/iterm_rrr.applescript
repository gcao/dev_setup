#! /usr/bin/osascript

tell application "iTerm" to activate
tell application "System Events"
  tell process "iTerm"
    key code 53 -- ESC
    -- keystroke F2 using shift down DOES NOT WORK!
    keystroke ":!rrr "
  end tell
end tell
