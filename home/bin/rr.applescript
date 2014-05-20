#! /usr/bin/osascript

#keystroke (ASCII character 30) -- up arrow key
#keystroke (ASCII character 31) -- down arrow key
#keystroke (ASCII character 29) -- right arrow key
#keystroke (ASCII character 28) -- left arrow key

-- http://geert.vanderkelen.org/splitting-as-string-and-joining-a-list-using-applescript/
to joinList(aList, delimiter)
	set retVal to ""
	set prevDelimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to delimiter
	set retVal to aList as string
	set AppleScript's text item delimiters to prevDelimiter
	return retVal
end joinList

on run argv
	set cmd to joinList(argv, " ")
	set the clipboard to cmd
	
	tell application "iTerm" to activate
	tell application "System Events"
		tell process "iTerm"
			keystroke "l" using {control down, shift down}
			if cmd is "C-c" or cmd is "c-c" then
				tell application "System Events" to keystroke "c" using control down
			else if cmd is "C-d" or cmd is "c-d" then
				tell application "System Events" to keystroke "d" using control down
			else if cmd is "C-k" or cmd is "c-k" then
				tell application "System Events" to keystroke "k" using command down
			else if cmd is "down" or cmd is "C-S-j" or cmd is "c-s-j" then
				tell application "System Events" to keystroke "j" using {control down, shift down}
			else if cmd is "up" or cmd is "C-S-k" or cmd is "c-s-k" then
				tell application "System Events" to keystroke "k" using {control down, shift down}
			else
				-- paste content
				tell application "System Events" to keystroke "v" using command down
				keystroke return
			end if
			
			delay 0.2
			#keystroke "h" using {control down, shift down}
			keystroke "b" using {control down}
			keystroke (ASCII character 28)
			
			keystroke return
		end tell
	end tell
end run

