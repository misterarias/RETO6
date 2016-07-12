#!/bin/bash
TOPDIR=$(cd $(dirname $0)/../ ; pwd)

# Create output directory - to be mounted by Docker as a volume
OUTDIR="${TOPDIR}/flink"
rm -rf "$OUTDIR" 

# Download to temporary file
FLINK_TGZ="$(mktemp /tmp/.flinkXXXXX)"
curl -Lo ${FLINK_TGZ} http://ftp.cixug.es/apache/flink/flink-1.0.3/flink-1.0.3-bin-hadoop27-scala_2.11.tgz

# unpack in a temporary location, and move result on success
TMPDIR=$(mktemp -d /tmp/.flinkXXXX.install)
tar -xvzf "$FLINK_TGZ" -C "$TMPDIR" && mv "$TMPDIR/flink-1.0.3" "$OUTDIR" 
if [ -f "$OUTDIR/README.txt" ] ; then
  echo "Success!"
  rm -rf "$FLINK_TGZ" "$TMPDIR"
else
  echo "Process has failed, check logs..."
  exit 1
fi
