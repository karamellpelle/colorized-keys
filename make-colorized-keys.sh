#!/bin/bash
DATA_DIR_PANDOC_TEMPLATES="$(pwd)/data-dir/colorized-keys/pandoc/templates/"
DATA_DIR_GRAPHICS="$(pwd)/graphics/" # / at end is necessary!
DATA_DIR_SETTINGS="$(pwd)/latex/" 

FILTER_EXE=${FILTER_EXE:-"$(stack path --local-install-root 2> /dev/null)/bin/colorized-filter"}
echo "using filter $FILTER_EXE"

pandoc --filter $FILTER_EXE \
       --variable data-dir-graphics=$DATA_DIR_GRAPHICS \
       --variable data-dir-pandoc-templates=$DATA_DIR_PANDOC_TEMPLATES \
       --variable data-dir-settings=$DATA_DIR_SETTINGS \
       --defaults=./pandoc-colorized.yaml \
       --from=markdown \
       --to=latex \
