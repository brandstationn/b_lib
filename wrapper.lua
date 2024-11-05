
function CheckLibraryVersion()
	if IsDuplicityVersion() then
        local currentVersion = "^3"..GetResourceMetadata("b_lib", 'version'):gsub("%.", "^7.^3").."^7"
        local githubMaster = 'https://raw.githubusercontent.com/brandstationn/b_lib/master/version.txt'
        PerformHttpRequest(githubMaster, function(err, newestVersion, headers)
            if not newestVersion then
                print("^1Unable to run a version check: ^7'^3b_lib^7' ("..currentVersion.."^7)")
                return
            end

            -- Remove unwanted characters at the end of the string, such as newlines or carriage returns
            newestVersion = newestVersion:gsub("%s+", "") -- Trim whitespace, including \n and \r

            -- Format the version string for display with colors
            newestVersion = "^3" .. newestVersion:gsub("%.", "^7.^3") .. "^7"

            -- Output the current and newest version
            print(newestVersion)
            print(currentVersion)

            -- Compare versions and print appropriate message
            print(newestVersion == currentVersion and
                "^7'^3[ b_lib ]^7' - ^6You are running the latest version.^7 ("..currentVersion..")" or
                "^7'^3[ b_lib ]^7' - ^1You are currently running an outdated version^7, ^1update version on brandstation github.^7"
            )
        end)
	end
end
CheckLibraryVersion()