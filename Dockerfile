FROM ubuntu:21.04

ARG METABASE_VERSION

ENV FC_LANG en-US LC_CTYPE en_US.UTF-8

# dependencies
RUN apt-get update -yq && apt-get install -yq bash fonts-dejavu-core fonts-dejavu-extra fontconfig curl openjdk-11-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    mkdir -p /app/certs && \
    curl https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -o /app/certs/rds-combined-ca-bundle.pem  && \
    keytool -noprompt -import -trustcacerts -alias aws-rds -file /app/certs/rds-combined-ca-bundle.pem -keystore /etc/ssl/certs/java/cacerts -keypass changeit -storepass changeit && \
    curl https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem -o /app/certs/DigiCertGlobalRootG2.crt.pem  && \
    keytool -noprompt -import -trustcacerts -alias azure-cert -file /app/certs/DigiCertGlobalRootG2.crt.pem -keystore /etc/ssl/certs/java/cacerts -keypass changeit -storepass changeit && \
    mkdir -p /plugins && chmod a+rwx /plugins && \
    useradd --shell /bin/bash metabase


WORKDIR /app

# copy app from the offical image
COPY --from=metabase/metabase:v0.35.4 /app /app

# Make sure the build-arg METABASE_VERSION matches what's in the COPY command
# above, since we can't use build-args in a COPY command.
RUN bash -c "[[ $(/app/run_metabase.sh help | awk '/Metabase v/ { print $2}' ) == ${METABASE_VERSION} ]]"

RUN chown -R metabase /app

USER metabase
# expose our default runtime port
EXPOSE 3000

# run it
ENTRYPOINT ["/app/run_metabase.sh"]
