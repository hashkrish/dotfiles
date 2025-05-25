# List last 10 modified files in the current directory
def lst [] {
    ls | sort-by -r modified | first 10
}

# Creates a new directory in ~/tmp with the next available number
def tmp [] {
  echo 1 1
  let last_file = (ls ~/tmp -s |
    where name =~ '^[0-9]+$' |
    get name |
    sort-by {|x| $x | into int } -r |
    get 0)
  let new_dir = ($last_file | into int) + 1
  echo $new_dir $last_file
  mkdir $"($env.HOME)/tmp/($new_dir)"
  cd $"($env.HOME)/tmp/($new_dir)"
}

# Goes to the last created directory in ~/tmp
def ltmp [prev_by: int = 0] {
  let last_file = (ls ~/tmp -s | where name =~ '^[0-9]+$' | get name | sort-by {|x| $x | into int } -r | get 0)
  let target = ($last_file | into int) - $prev_by
  cd $"($env.HOME)/tmp/($target)"
}

# Opens the path to an executable in Neovim
def nvim-which [cmd: string] {
  nvim (which $cmd | get 0.path)
}

def foo [] {
  echo 1
}

def dps [] {
  docker ps |
  from ssv -a |
  select NAMES STATUS IMAGE |
  sort-by NAMES
}

def dpsa [] {
  docker ps -a |
  from ssv -a |
  select NAMES STATUS IMAGE |
  sort-by NAMES
}
