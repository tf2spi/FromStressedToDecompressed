# Intro / RLE (De)compression

Hello! Welcome to *From Stressed to Decompressed*, a
tutorial on (de)compression techniques used today
for archiving locally as well as transfer over
the network.

We start by introducing ``RLE`` compression,
which is usually the first lossless (de)compression
technique tested to compress data when hardware
and software constraints require it just due to
how simple it is.

## Reference

A custom ``RLE`` algorithm is used for this tutorial.

Decompression of it can be summarized by the following steps
in a loop until all the data has been read.

* Read a byte "b" from the data
  - If (b != 0xff), this is the next byte of decompressed data
  - If (b == 0xff), read 2 more bytes.
    * The second byte describes the next byte of decompressed data
    * The first byte describes how many more times to use this second byte

For example:
```
             Decompress
44 45 41 44     ->       44 45 41 44
FF 03 44        ->       44 44 44 44

```

