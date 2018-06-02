# teredb

Dead simple SSTable implementation in Haskell.

## Quickstart

Assuming Docker is installed and we're in `teredb` directory.

```bash
$ docker build -t teredb:0.0.1 .
$ docker run -it --mount type=bind,source="$(pwd)",target=/app --rm teredb:0.0.1
$ cd /app && stack ghci
```
