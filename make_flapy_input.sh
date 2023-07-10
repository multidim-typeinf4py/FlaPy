#!/usr/bin/env bash

IN_DIR=$1/repos/test
OUT_CSV=$1/flapy_input.csv

rm "$OUT_CSV"


echo "PROJECT_NAME,PROJECT_URL,PROJECT_HASH,PYPI_TAG,FUNCS_TO_TRACE,TESTS_TO_BE_RUN,NUM_RUNS" >"$OUT_CSV"

while IFS= read -r -d $'\0' project; do
    if [[ -f "$project"/poetry.lock ]]; then
        (cd "$project" && poetry export -f requirements.txt \
            --output "$project"/poetry-requirements.txt \
            --with dev \
            --without-hashes)
    fi

    copied=""
    for requirement in "$project"/{*requirements*.txt,Pipfile,poetry.lock}; do
        if [[ -f $requirement ]]; then
            path=$(realpath "$project")
            base=$(basename "$project")
    
            echo "$base,$path,,,,,1" >>"$OUT_CSV"
    
            copied="used"
            break
        fi

    done

    [[ ! $copied ]] && echo "Cannot use $project"
done < <(find "$IN_DIR" -mindepth 1 -maxdepth 1 -type d -print0)
