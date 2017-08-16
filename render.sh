#!/usr/bin/env sh
# Renders all parts requried for 3D printing a full Stenoboard.
# This creates STL files using OpenSCAD.
# NOTE: This might take quite some time (at least minutes, up to 2 or 3 hours),
#   depending on your hardware.

openscad  stenoboard.scad --render \
	-o rightBase.stl \
	-DRENDER_BASE_RIGHT=true

openscad  stenoboard.scad --render \
	-o leftBase.stl \
	-DRENDER_BASE_LEFT=true

openscad  stenoboard.scad --render \
	-o consonants.stl \
	-DRENDER_CONSONANTS=true

openscad  stenoboard.scad --render \
	-o vowels.stl \
	-DRENDER_VOWELS=true

openscad  stenoboard.scad --render \
	-o numbers.stl \
	-DRENDER_NUMBER=true

openscad  stenoboard.scad --render \
	-o barButtonContact.stl \
	-DRENDER_CONTACT=true

