#!/bin/bash
DATA_DIR="$(pwd)/data-dir/colorized-keys"
DATA_DIR_FONTS="$DATA_DIR/fonts/"
DATA_DIR_PANDOC="$DATA_DIR/pandoc"
DATA_DIR_PANDOC_TEMPLATES="$DATA_DIR_PANDOC/templates/"

OUTPUT_FILE="./colorized-keys.pdf"
OUTPUT_FORMAT="pdf"

INPUT_FILES="./text/front.md ./text/keys.md ./text/style.md"

PDF_ENGINE=xelatex
OTHER_OPTS="$3 "

DEFAULTS_FILE="./defaults.yaml"

FILTER_EXE=${FILTER_EXE:-"$(stack path --local-install-root 2> /dev/null)/bin/colorized-keys-filter"}
echo "using filter $FILTER_EXE"


pandoc --data-dir=$DATA_DIR_PANDOC \
       --variable data-dir=$DATA_DIR_PANDOC \
       --variable data-dir-pandoc-templates=$DATA_DIR_PANDOC_TEMPLATES \
       --template=default.latex \
       --pdf-engine=$PDF_ENGINE \
       --defaults=$DEFAULTS_FILE \
       --filter $FILTER_EXE \
       --to=$OUTPUT_FORMAT \
       -o "$OUTPUT_FILE" \
       $INPUT_FILES
