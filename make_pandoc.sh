#!/bin/bash
DATA_DIR="$(pwd)/data-dir/colorized-keys"
DATA_DIR_PANDOC="$DATA_DIR/pandoc"

OUTPUT_FILE="colorized-keys.pdf"
OUTPUT_FORMAT="pdf"

INPUT_FILES="text/style.md text/front.md text/keys.md"
#INPUT_FILES=text/style.md 


PDF_ENGINE=xelatex
OTHER_OPTS="$3 "

DEFAULTS_FILE=defaults.yaml
DATA_DIR_FONTS="$DATA_DIR_PANDOC/fonts/"
DATA_DIR_TEMPLATES="$DATA_DIR_PANDOC/templates/"

FILTER_EXE=${FILTER_EXE:-"$(stack path --local-install-root 2> /dev/null)/bin/colorized-keys-filter"}
echo "using filter $FILTER_EXE"
OTHER_OPTS="$OTHER_OPTS --filter $FILTER_EXE"

pandoc --data-dir=$DATA_DIR_PANDOC \
       --variable data-dir=$DATA_DIR_PANDOC \
       --variable data-dir-fonts=$DATA_DIR_FONTS \
       --variable data-dir-templates=$DATA_DIR_TEMPLATES \
       --template=default.latex \
       --pdf-engine=$PDF_ENGINE \
       --defaults=$DEFAULTS_FILE \
       $OTHER_OPTS \
       --to=$OUTPUT_FORMAT \
       -o "$OUTPUT_FILE" \
       $INPUT_FILES


