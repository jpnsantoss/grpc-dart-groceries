#!/bin/bash

# Directory where your .proto files are stored
PROTO_DIR="./protos/"

# Directory where the generated Dart code should be placed
OUT_DIR="./lib/src/generated"

# Iterate over each .proto file in the directory
for PROTO_FILE in $PROTO_DIR*.proto
do
  # Compile the .proto file to Dart code
  protoc --dart_out=grpc:$OUT_DIR -I$PROTO_DIR $PROTO_FILE
done

echo "Compilation finished."