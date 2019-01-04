// Create packages for all files

// Set directory
global directory "/Users/bbdaniels/GitHub/bbd-stata"
cd "${directory}"

  // Remove TOC
  !rm "${directory}/stata.toc"

  // Delete all packages and submission zips
  !rm *.pkg
  !rm *.zip

  // Start writing new TOC
  file close _all
  file open toc using "${directory}/stata.toc" , write
  	file write toc "v 0.1"  _n "d Benjamin Daniels"  _n

  // Find all adofiles in /src/
  local adoFiles : dir `"${directory}/src/"' dirs "*"

  // Write all adofiles into TOC and zip into packages
  foreach file in `adoFiles' {
  	local ado : dir `"${directory}/src/`file'/"' files "*.ado"
  	local hlp : dir `"${directory}/src/`file'/"' files "*.sthlp"

  	file write toc "p `file' `file'"  _n

  	file open `file' using "${directory}/`file'.pkg" , write
  		file write `file' "v 0.1"  _n "d Benjamin Daniels"  _n

  	local items ""
  	foreach item in `ado' `hlp' {
  		local items "`items' ${directory}/src/`file'/`item'"
  		file write `file' "f /src/`file'/`item'" _n
  	}
  	file close `file'

  	!zip `file'.zip `items'
  }

  // Finish writing TOC
  file close toc

// All packed!