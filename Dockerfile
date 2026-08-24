# Viseron with PCIe Coral EdgeTPU support
#
# Extends the official Viseron image with PCIe Coral firmware and drivers
# for Google Coral EdgeTPU PCIe accelerator cards.

ARG VISERON_VERSION=latest-amd64
FROM roflcoopter/viseron:${VISERON_VERSION} AS base

# Build stage: fetch Coral PCIe firmware
FROM alpine:3.20 AS firmware

# Install curl for downloading
RUN apk add --no-cache curl

# Coral PCIe firmware (from Google Coral releases)
# Firmware is included in libedgetpu1-max package, but we can also fetch from releases
ENV CORAL_FIRMWARE_VERSION=16.0
RUN mkdir -p /firmware && \
    curl -fsSL "https://github.com/google-coral/edgetpu/releases/download/v${CORAL_FIRMWARE_VERSION}/edgetpu_firmware.bin" \
    -o /firmware/edgetpu_firmware.bin && \
    chmod 644 /firmware/edgetpu_firmware.bin

# Final image
FROM base AS viseron-coral-pcie

# Copy firmware to system firmware directory
COPY --from=firmware /firmware/edgetpu_firmware.bin /lib/firmware/edgetpu_firmware.bin

# Ensure libedgetpu1-max is installed (includes PCIe kernel module support)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libedgetpu1-max \
    && rm -rf /var/lib/apt/lists/*

# udev rules for Coral PCIe devices
RUN echo 'SUBSYSTEM=="pci", ATTR{vendor}=="0x1ac1", ATTR{device}=="0x089a", MODE="0660", GROUP="video"' > /etc/udev/rules.d/99-coral-pcie.rules

# Label the image
LABEL org.opencontainers.image.title="Viseron with PCIe Coral EdgeTPU" \
      org.opencontainers.image.description="Viseron NVR with Google Coral EdgeTPU PCIe support" \
      org.opencontainers.image.source="https://github.com/yourusername/viseron-coral-pcie" \
      org.opencontainers.image.licenses="MIT"

# Entry point remains the same as base Viseron
ENTRYPOINT ["/init"]