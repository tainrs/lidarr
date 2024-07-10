# This Dockerfile is used to create a Docker image for Lidarr.
# It pulls an upstream image, sets up the environment, installs dependencies,
# installs Plex Media Server, and prepares the configuration.

# Define arguments for the upstream image and its digest for AMD64 architecture
ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_AMD64

# Use the upstream image as the base image for this Dockerfile
FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_AMD64}

# Expose port 8686 for Lidarr
EXPOSE 8686

# Define arguments and environment variables
ARG IMAGE_STATS
ENV IMAGE_STATS=${IMAGE_STATS} WEBUI_PORTS="8686/tcp,8686/udp"

# Update the package list and install required dependencies
RUN apk add --no-cache libintl sqlite-libs icu-libs chromaprint

ARG VERSION
ARG BRANCH
ARG PACKAGE_VERSION=${VERSION}

# Create a directory for the application binary and download Radarr
RUN set -e ;\
    mkdir "${APP_DIR}/bin" ;\
    curl -fsSL "https://lidarr.servarr.com/v1/update/${BRANCH}/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=x64" | tar xzf - -C "${APP_DIR}/bin" --strip-components=1 ;\
    rm -rf "${APP_DIR}/bin/Lidarr.Update" ;\
    rm -f "${APP_DIR}/bin/fpcalc"

# Create a package_info file with version and author information
RUN echo -e "PackageVersion=${PACKAGE_VERSION}\nPackageAuthor=[tainrs](https://github.com/tainrs)\nUpdateMethod=Docker\nBranch=${BRANCH}" > "${APP_DIR}/package_info"

# Set appropriate permissions for the application directory
RUN chmod -R u=rwX,go=rX "${APP_DIR}"

# Copy the root directory to the container
COPY root/ /
