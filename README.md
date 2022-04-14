This is a build of metabase for ARM; instructions/Dockerfile from
https://github.com/metabase/metabase/issues/13119#issuecomment-1000350647.

Would love to use the upstream instead, but there's been no response from
metabase staff re: making an official ARM build.

To build a new version, set `METABASE_TAG` in `./github/workflows/docker.yml`,
_and_ a matching version in the `COPY --from=` line in `Dockerfile`. (The
Dockerfile has a `RUN` to confirm that these two values are equal.)

Because we're using buildx and QEMU (because Github Actions doesn't have ARM
builders yet), this is not fast. Fortunately, we don't expect to build this
often.
