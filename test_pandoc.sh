#!/bin/bash
DATA_DIR="$(pwd)/data-dir/colorized-keys"
DATA_DIR_FONTS="$DATA_DIR/fonts/"
DATA_DIR_PANDOC="$DATA_DIR/pandoc"
DATA_DIR_PANDOC_TEMPLATES="$DATA_DIR_PANDOC/templates/"
DATA_DIR_GRAPHICS="$(pwd)/graphics/" # / at end is necessary!

INPUT_FILE=${1:-text/colorized-keys.md}
OUTPUT_FILE=$(basename "$INPUT_FILE" )


#OUTPUT_FORMAT=${OUTPUT_FILE#*.}
INPUT_FORMAT=${INPUT_FILE#*.}
OUTPUT_FORMAT=${2:-pdf}

INPUT_FORMAT=${INPUT_FORMAT/md/markdown}

OUTPUT_FILE="output/${OUTPUT_FILE%.*}.${OUTPUT_FORMAT}"

#PDF_ENGINE=lualatex
PDF_ENGINE=xelatex

OTHER_OPTS="$3 "

echo "INPUT_FILE:   $INPUT_FILE"
echo "OUTPUT_FILE:  $OUTPUT_FILE"
echo "INPUT_FORMAT: $INPUT_FORMAT"
echo "INPUT_FORMAT: $OUTPUT_FORMAT"

DEFAULTS_FILE="./pandoc-colorized.yaml"

FILTER_EXE=${FILTER_EXE:-"$(stack path --local-install-root 2> /dev/null)/bin/colorized-keys-filter"}
echo "using filter $FILTER_EXE"
OTHER_OPTS="$OTHER_OPTS --filter $FILTER_EXE"

pandoc --data-dir=$DATA_DIR_PANDOC \
       --variable data-dir-graphics=$DATA_DIR_GRAPHICS \
       --variable data-dir-pandoc-templates=$DATA_DIR_PANDOC_TEMPLATES \
       --template=colorized.latex \
       --defaults=$DEFAULTS_FILE \
       --pdf-engine=$PDF_ENGINE \
       $OTHER_OPTS \
       --from=$INPUT_FORMAT \
       --to=$OUTPUT_FORMAT \
       -o "$OUTPUT_FILE" \
       "$INPUT_FILE" text/keys.md text/front.md \
       \
       && open "$OUTPUT_FILE"

