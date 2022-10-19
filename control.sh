#!/bin/sh

if [ -z "$VERSION" ]; then
    >&2 echo "Must specify VERSION env var"
    exit 1
fi

DEPENDS=$(cat embassyos-$VERSION/build/lib/depends | tr $'\n' ',')
CONFLICTS=$(cat embassyos-$VERSION/build/lib/conflicts | tr $'\n' ',')

cat > embassyos-$VERSION/debian/control << EOF
Source: embassyos
Section: unknown
Priority: required
Maintainer: Aiden McClelland <aiden@start9labs.com>
Build-Depends: debhelper-compat (= 12) 
Standards-Version: 4.5.0
Homepage: https://start9.com

Package: embassyos
Architecture: any
Multi-Arch: foreign
Depends: ${DEPENDS}\${shlibs:Depends}
Conflicts: ${CONFLICTS}
Description: embassyOS Debian Package
EOF