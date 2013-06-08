# d3 export demo
This is a proof-of-concept demo for saving d3js graphics as PDF/PNG/SVG files.

## Objective
CGI takes incoming SVG serialization.
Use graphics toolkit to open SVG serialization as input, output PNG or PDF as
output.

This perl implementation just performs a system call on `rsvg-convert`, nothing
specific to perl.

## Options
* librsvg
* imagemagick
  http://stackoverflow.com/questions/15119679/converting-an-svg-with-imagemagick
* batik

See http://stackoverflow.com/questions/4809194/convert-svg-image-to-png-with-php
for another nice overview.
We just run `rsvg-convert` [`man rsvg`](http://www.unix.com/man-page/all/1/rsvg/)
* http://superuser.com/questions/381125/how-do-i-convert-an-svg-to-a-pdf-on-linux

## Implementation
See here for more details:
	* https://github.com/agordon/d3export_demo

See here for online demo:
	http://d3export.cancan.cshl.edu/

## License
Copyright (C) 2012 by A. Gordon (gordon at cshl dot edu)
All code written by me is released under BSD license: http://opensource.org/licenses/BSD-3-Clause
(also uses several other libraries that have their own licenses).

