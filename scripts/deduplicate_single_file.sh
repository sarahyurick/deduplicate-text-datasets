INPUT_FILE=/path/to/input/file.jsonl
THRESHOLD=50
CACHE=/path/to/cache/
DROP_TOKENS_FILE=/path/to/drop_tokens_file
DEDUPED_FILE=/path/to/output/file_deduped.jsonl

start_time=$(date +%s)
python3 scripts/make_suffix_array.py $INPUT_FILE
end_time=$(date +%s)
elapsed=$((end_time - start_time))
echo "Time taken to make suffix array: $elapsed seconds"

start_time=$(date +%s)
cargo run self-similar --data-file $INPUT_FILE --length-threshold $THRESHOLD --cache-dir $CACHE
end_time=$(date +%s)
elapsed=$((end_time - start_time))
echo "Time taken to run self-similar: $elapsed seconds"

start_time=$(date +%s)
cargo run collect --data-file $INPUT_FILE --cache-dir $CACHE --length-threshold $THRESHOLD > $DROP_TOKENS_FILE
end_time=$(date +%s)
elapsed=$((end_time - start_time))
echo "Time taken to run collect: $elapsed seconds"

start_time=$(date +%s)
python3 scripts/finish_single_file.py $INPUT_FILE $DROP_TOKENS_FILE $DEDUPED_FILE
end_time=$(date +%s)
elapsed=$((end_time - start_time))
echo "Time taken to finish single file: $elapsed seconds"
