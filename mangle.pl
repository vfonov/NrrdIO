#
#  NrrdIO: stand-alone code for basic nrrd functionality
#  Copyright (C) 2005  Gordon Kindlmann
#  Copyright (C) 2004, 2003, 2002, 2001, 2000, 1999, 1998  University of Utah
# 
#  This software is provided 'as-is', without any express or implied
#  warranty.  In no event will the authors be held liable for any
#  damages arising from the use of this software.
# 
#  Permission is granted to anyone to use this software for any
#  purpose, including commercial applications, and to alter it and
#  redistribute it freely, subject to the following restrictions:
# 
#  1. The origin of this software must not be misrepresented; you must
#     not claim that you wrote the original software. If you use this
#     software in a product, an acknowledgment in the product
#     documentation would be appreciated but is not required.
# 
#  2. Altered source versions must be plainly marked as such, and must
#     not be misrepresented as being the original software.
# 
#  3. This notice may not be removed or altered from any source distribution.
#
#
# generates (to stdout) a header file intended to be included into
# source files where there is a concern of name-space collision induced
# by linking to two different version of NrrdIO
#
# You probably shouldn't run this on a mac: all symbols are preceeded by _
#

if (0 != $#ARGV) {
    die "usage: perl mangle.pl <prefix>\n";
}
$prefix = $ARGV[0];

print "#ifndef ${prefix}_NrrdIO_mangle_h\n";
print "#define ${prefix}_NrrdIO_mangle_h\n";
print "\n";
print "/*\n";
print "\n";
print "This header file mangles all symbols exported from the\n";
print "NrrdIO library. It is included in all files while building\n";
print "the NrrdIO library.  Due to namespace pollution, no NrrdIO\n";
print "headers should be included in .h files in ITK.\n";
print "\n";
print "This file was created via the mangle.pl script in the\n";
print "NrrdIO distribution:\n";
print "\n";
print "  perl mangle.pl ${prefix} > ${prefix}_NrrdIO_mangle.h\n";
print "\n";
print "This uses nm to list all text (T) and data (D) symbols\n";
print "*/\n";
print "\n";
open(NM, "nm libNrrdIO.a |");
while (<NM>) {
    if (m/ [TD] /) {
	s|.* [TD] (.*)|$1|g;
	chop;
	$sym = $_;
	print "#define ${sym} ${prefix}_${sym}\n";
    }
}
close(NM);
print "#endif\n";
