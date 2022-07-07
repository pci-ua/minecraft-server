#!/usr/bin/env bash
# Debian/Ubuntu doesn't ship the imagemagick package with the 'magick' binary, so this is a stop-gap solution for this.
error() {
    echo "Invalid argument." > /dev/stderr
    exit # No exit code on purpose
}

if [[ -z $1 ]]; then
    error
fi

case $1 in
    animate)
        shift
        exec animate $@
        ;;

    composite)
        shift
        exec composite $@
        ;;

    conjure)
        shift
        exec conjure $@
        ;;

    convert)
        shift
        exec convert $@
        ;;

    display)
        shift
        exec display $@
        ;;

    identify)
        shift
        exec identify $@
        ;;

    import)
        shift
        exec import $@
        ;;

    mogrify)
        shift
        exec mogrify $@
        ;;

    montage)
        shift
        exec montage $@
        ;;
        
    -version)
    	echo 'Passthrough script version 1.0.'
    	exit
    	;;

    *)
        error
        ;;
esac
