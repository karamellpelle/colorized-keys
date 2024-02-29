#!/bin/sh
DATA_DIR="./data-dir/colorized-keys/pandoc"
INPUT_FILE=${1:-text/colorized-keys.md}
OUTPUT_FILE=$(basename "$INPUT_FILE" )

#OUTPUT_FORMAT=${OUTPUT_FILE#*.}
INPUT_FORMAT=${INPUT_FILE#*.}
OUTPUT_FORMAT=${2:-pdf}

INPUT_FORMAT=${INPUT_FORMAT/md/markdown}

OUTPUT_FILE="output/${OUTPUT_FILE%.*}.${OUTPUT_FORMAT}"

PDF_ENGINE=xelatex
#PDF_ENGINE=pdflatex

OTHER_OPTS="--listings $3"
echo "INPUT_FILE:   $INPUT_FILE"
echo "OUTPUT_FILE:  $OUTPUT_FILE"
echo "INPUT_FORMAT: $INPUT_FORMAT"
echo "INPUT_FORMAT: $OUTPUT_FORMAT"

pandoc --data-dir=$DATA_DIR --template=default.latex --pdf-engine=$PDF_ENGINE $OTHER_OPTS --from=$INPUT_FORMAT --to=$OUTPUT_FORMAT -o "$OUTPUT_FILE" "$INPUT_FILE" \
    && open "$OUTPUT_FILE"

