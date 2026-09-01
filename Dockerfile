# Viseron with PCIe Coral EdgeTPU support
#
# Extends the official Viseron image with PCIe Coral firmware and drivers
# for Google Coral EdgeTPU PCIe accelerator cards.

ARG VISERON_VERSION=v3.6.1
FROM roflcoopter/viseron:${VISERON_VERSION}

# Ensure libedgetpu1-max is installed (includes PCIe kernel module + firmware)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libedgetpu1-max \
    && rm -rf /var/lib/apt/lists/*

# Autotrack deps: Norfair translation estimator + Prometheus metrics
# (kept minimal per cardinality guidance; ~12 series)
RUN python3 -m pip install --no-cache-dir norfair==2.3.0 prometheus_client==0.26.0

# udev rules for Coral PCIe devices
RUN mkdir -p /etc/udev/rules.d && \
    echo 'SUBSYSTEM=="pci", ATTR{vendor}=="0x1ac1", ATTR{device}=="0x089a", MODE="0660", GROUP="video"' > /etc/udev/rules.d/99-coral-pcie.rules

# Label the image
LABEL org.opencontainers.image.title="Viseron with PCIe Coral EdgeTPU" \
      org.opencontainers.image.description="Viseron NVR with Google Coral EdgeTPU PCIe support" \
      org.opencontainers.image.source="https://github.com/syscod3/viseron-coral-pcie" \
      org.opencontainers.image.licenses="MIT"

# Entry point remains the same as base Viseron
ENTRYPOINT ["/init"]