# Script architecture

## Define package manager
define apt, dnf, pacman.
**How?**
    > Instead of identifying binary programs, you should start from identifying distributions.
    > 
    > Hare are a few lines that works in bash scripting:
    > 
    > declare -A osInfo;
    > osInfo[/etc/debian_version]=apt
    > osInfo[/etc/fedora-release]=dnf
    > osInfo[/etc/arch-release]=pacman
    > 
    > for f in ${!osInfo[@]}
    > do
    >     if [[ -f $f ]];then
    >         echo Package manager: ${osInfo[$f]}
    >     fi
    > done
    > 
    > Althrough it is possible for these files to be modified so that this method will fail, that would be a highly non-standard configuration so this should work in most situations.
**Thing:** "Interesting..."

## Make associative arrays
Because itch package manager has your unic naming for the same packages.
**How?**
```bash
    # Declare an associative array
    declare -A STAR_PLAYERS
    
    # Add elements to the associative array
    STAR_PLAYERS[Argentina]="Messi"
    STAR_PLAYERS[Brazil]="Neymar"
    STAR_PLAYERS[England]="Kane"
    
    # Print the value of a specific key
    echo ${STAR_PLAYERS[Argentina]} # Outputs: Messi
```
```bash
    # Assume we have an associative array named example_array
    declare -A example_array
    example_array["key1"]="value1"
    
    # Add a new key-value pair to the array
    example_array["new_key"]="new_value"
```
**Think:** "this is clear, and I have an idea to use it."

## Checking installed packages and download or exit
**How?**
    > To check if packagename was installed, type:
    > 
    > dpkg -s <packagename>
    > 
    > You can also use dpkg-query that has a neater output for your purpose, and accepts wild cards, too.
    > 
    > dpkg-query -l <packagename>
    > 
    > To find what package owns the command, try:
    > 
    > dpkg -S `which <command>`
    > 
    > You can use these in an if statement in bash like this:
    > 
    > if dpkg -s desired-pkg-name &>/dev/null; then
    >   echo 'desired-pkg-name is installed'
    > fi
    > 
    > For further details, see article Find out if package is installed in Linux and dpkg cheat sheet.

## flatpak-apps installing
**How to check installation and install?**
**Answer:** as think as in package manager?
```bash
flatpak info <app_id> &>/dev/null
```
```bash
flatpak install -y flathub <app_id>
```

## External packages
this I need to check itch official sites and use installation, but i don't understand how to check it firct if it was installed?

