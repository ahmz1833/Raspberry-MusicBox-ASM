#!/bin/sh
# Some modification
set -e         # Exit on error

AS="as"
LD="ld"

$AS -o tmp.o main.s

# Link the object file
$LD -o main.out tmp.o

# Remove the object file
rm tmp.o

# Kill the program if it is already running
sudo pkill -f main.out || true

# Run the program with High priority
sudo nice -n -20 ./main.out
