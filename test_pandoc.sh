#!/bin/bash
DATA_DIR="$(pwd)/data-dir/colorized-keys/pandoc"
INPUT_FILE=${1:-text/colorized-keys.md}
OUTPUT_FILE=$(basename "$INPUT_FILE" )

#OUTPUT_FORMAT=${OUTPUT_FILE#*.}
INPUT_FORMAT=${INPUT_FILE#*.}
OUTPUT_FORMAT=${2:-pdf}

INPUT_FORMAT=${INPUT_FORMAT/md/markdown}

OUTPUT_FILE="output/${OUTPUT_FILE%.*}.${OUTPUT_FORMAT}"

PDF_ENGINE=xelatex

OTHER_OPTS="$3 "

echo "INPUT_FILE:   $INPUT_FILE"
echo "OUTPUT_FILE:  $OUTPUT_FILE"
echo "INPUT_FORMAT: $INPUT_FORMAT"
echo "INPUT_FORMAT: $OUTPUT_FORMAT"

DEFAULTS_FILE="$DATA_DIR/defaults.yaml"
DATA_DIR_FONTS="$DATA_DIR/fonts/"
DATA_DIR_TEMPLATES="$DATA_DIR/templates/"

FILTER_EXE=${FILTER_EXE:-"$(stack path --local-install-root 2> /dev/null)/bin/colorized-keys-filter"}
echo "using filter $FILTER_EXE"
OTHER_OPTS="$OTHER_OPTS --filter $FILTER_EXE"

pandoc --data-dir=$DATA_DIR \
       --variable data-dir=$DATA_DIR \
       --variable data-dir-fonts=$DATA_DIR_FONTS \
       --variable data-dir-templates=$DATA_DIR_TEMPLATES \
       --template=default.latex \
       --defaults=$DEFAULTS_FILE \
       --pdf-engine=$PDF_ENGINE \
       $OTHER_OPTS \
       --from=$INPUT_FORMAT \
       --to=$OUTPUT_FORMAT \
       -o "$OUTPUT_FILE" \
       "$INPUT_FILE" \
       \
       && open "$OUTPUT_FILE"

