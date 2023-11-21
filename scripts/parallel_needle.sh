#!/bin/bash
# Set the maximum number of parallel jobs
max_jobs=6
# Function to process a single line from the CSV
process_line() {
    # Read CSV fields into variables
    local id1=$1
    local id2=$2
    local seq1=$3
    local seq2=$4
    # Create temporary FASTA files
    local tmp1=$(mktemp)
    local tmp2=$(mktemp)
    echo ">${id1}" > "$tmp1"
    echo "$seq1" >> "$tmp1"
    echo ">${id2}" > "$tmp2"
    echo "$seq2" >> "$tmp2"
    # Run needle
    needle -asequence "$tmp1" -bsequence "$tmp2" -gapopen 10 -gapextend 0.5 -outfile "${id1}_${id2}_alignment.needle"
    # Clean up temporary files
    rm "$tmp1" "$tmp2"
}
export -f process_line
# Read the CSV file and skip the header
tail -n +2 SL3.0_to_SL5.0_converter_seq.csv | \
# Use parallel to process each line using the defined function
parallel -j $max_jobs --colsep ',' process_line {1} {2} {3} {4}
