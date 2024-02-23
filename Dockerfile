# Use an existing OSRM Docker image
FROM ghcr.io/project-osrm/osrm-backend

# Install necessary packages including wget
RUN apt-get update && apt-get install wget ca-certificates -y --no-install-recommends curl

# Download OSM data for Greece
RUN mkdir /data && \
    wget -O /data/greece-latest.osm.pbf https://download.geofabrik.de/europe/greece-latest.osm.pbf

# Extract data and generate routing graphs
RUN osrm-extract -p /opt/car.lua /data/greece-latest.osm.pbf && \
    osrm-partition /data/greece-latest.osrm && \
    osrm-customize /data/greece-latest.osrm

# Expose OSRM HTTP server port
EXPOSE 5000

# Run OSRM HTTP server
CMD ["osrm-routed", "--algorithm", "mld", "/data/greece-latest.osrm"]
