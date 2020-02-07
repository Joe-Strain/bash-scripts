#!/bin/bash

# This script takes integers as input and outputs the:
# Average (mean), total, max, and min

# Error Message
if [ $# -lt 1 ]
then
	echo "Please enter a space sepearted list of integers"
	exit 1
fi

# Calculates total
total=0
for i in "$@"
do	
	total=$((total + $i))
done

# Calculates mean and prints to screen
n=$#
awk -v a="$total" -v b="$n" 'BEGIN {
mean=(a/b)
printf ("Average: %0.2f\n", mean) }'

# Finds max value
max=$1
for j in "$@"
do
	((j > max)) && max="$j"
done

# Finds min value
min=$1
for k in "$@"
do
	((k < min)) && min="$k"
done

# Prints remaining stats to screen
echo "Total: $total"
echo "Max: $max"
echo "Min: $min"

