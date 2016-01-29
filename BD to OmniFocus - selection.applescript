tell application "BibDesk"
	set thePubs to selection of document 1
	repeat with thePub in thePubs
		
		set theAuthors to (full name of authors of thePub)
		set au to ""
		set multipleAuthors to false
		repeat with theAuthor in theAuthors
			if multipleAuthors is true then
				set au to au & " and " & theAuthor
			else
				set au to theAuthor as string
				set multipleAuthors to true
			end if
		end repeat
		
		set ti to title of thePub as string
		set ye to publication year of thePub as string
		set ci to cite key of thePub as string
		set linkedURLs to linked URLs of thePub
		set linkedFiles to POSIX path of linked files of thePub
		set linkText to ""
		repeat with theLink in linkedURLs
			set linkText to linkText & "
" & theLink
		end repeat
		repeat with theFile in linkedFiles
			set linkText to linkText & "
file://" & my encode_text(theFile, false, true)
		end repeat
		
		tell application "OmniFocus"
			tell quick entry
				set _task to make new inbox task with properties {name:"Read 
" & (au & " (" & ye & "). " & ti & "."), note:"x-bdsk://" & ci & linkText}
				open
			end tell
		end tell
		
	end repeat
end tell

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

on encode_char(this_char)
	set the ASCII_num to (the ASCII number this_char)
	set the hex_list to {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
	set x to item ((ASCII_num div 16) + 1) of the hex_list
	set y to item ((ASCII_num mod 16) + 1) of the hex_list
	return ("%" & x & y) as string
end encode_char

on encode_text(this_text, encode_URL_A, encode_URL_B)
	set the standard_characters to "abcdefghijklmnopqrstuvwxyz0123456789"
	set the URL_A_chars to "$+!'/?;&@=#%><{}[]\"~`^\\|*"
	set the URL_B_chars to ".-_:"
	set the acceptable_characters to the standard_characters
	if encode_URL_A is false then set the acceptable_characters to the acceptable_characters & the URL_A_chars
	if encode_URL_B is false then set the acceptable_characters to the acceptable_characters & the URL_B_chars
	set the encoded_text to ""
	repeat with this_char in this_text
		if this_char is in the acceptable_characters then
			set the encoded_text to (the encoded_text & this_char)
		else
			set the encoded_text to (the encoded_text & encode_char(this_char)) as string
		end if
	end repeat
	return the encoded_text
end encode_text
