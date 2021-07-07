# resume tarball

INFILES="my folder"
OUTFILE="archive.tgz"
SIZE="$(wc -c < $OUTFILE)"; tar -cz --to-stdout "$INFILES" | tail -c +$(($SIZE+1)) >> "$OUTFILE"
