#! /bin/bash

source scripts/generate_page.sh
source scripts/validate_words.sh

TEMPLATE=wordle_template.html
WORDS_CSV=data/words.csv
main ${TEMPLATE} ${WORDS_CSV}