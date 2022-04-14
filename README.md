This is a build of metabase for ARM; instructions/Dockerfile from
https://github.com/metabase/metabase/issues/13119#issuecomment-1000350647.

Would love to use the upstream instead, but there's been no response from
metabase staff re: making an official ARM build.

To build a new version, set `METABASE_TAG` in `./github/workflows/docker.yml`.
