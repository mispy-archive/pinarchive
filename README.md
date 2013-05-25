## Installation

```gem install pinarchive```

Requires [curl](http://curl.haxx.se/)

## Usage

```pinarchive http://pinterest.com/USER/[BOARD] [OUTPUT_DIR]```

Archive a Pinterest board to a local directory. Will not download pins
that are already present, so may be invoked repeatedly to keep a copy
of a Pinterest account up to date!

If [BOARD] is omitted, all boards in the user's account will be downloaded.
New directories will be created for each board under [OUTPUT_DIR], which
defaults to the current working directory.
