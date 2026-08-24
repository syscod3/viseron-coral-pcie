# Viseron PCIe Coral EdgeTPU

Docker image extending [Viseron](https://github.com/roflcoopter/viseron) with Google Coral EdgeTPU PCIe support.

## Features

- Based on official `roflcoopter/viseron` image
- Includes Coral EdgeTPU PCIe firmware (`edgetpu_firmware.bin`)
- Installs `libedgetpu1-max` with PCIe kernel module support
- udev rules for PCIe Coral devices (`/dev/apex_*`)
- Ready for Viseron's EdgeTPU object detection with PCIe accelerators

## Quick Start

```bash
# Build locally
./build.sh

# Or with custom version
VISERON_VERSION=latest-amd64 ./build.sh

# Push to registry
PUSH=true REGISTRY=ghcr.io REPO=yourname/viseron-coral-pcie ./build.sh
```

## Usage with Viseron

```yaml
# docker-compose.yml
services:
  viseron:
    image: ghcr.io/yourname/viseron-coral-pcie:latest
    devices:
      - /dev/apex_0:/dev/apex_0
      - /dev/apex_1:/dev/apex_1
    # ... rest of Viseron config
```

## Viseron Configuration

```yaml
edgetpu:
  object_detector:
    model_type: yolo_generic
    model_path: /config/models/yolov9-s-relu6-best_320_int8_edgetpu.tflite
    label_path: /config/models/labels-coco17.txt
    device: :0  # or :1 for second TPU
```

## Supported Hardware

- Google Coral EdgeTPU PCIe (dual TPU card)
- Tested with `/dev/apex_0` and `/dev/apex_1`

## Building

### Local
```bash
# Default (latest Viseron)
./build.sh

# Specific Viseron version
VISERON_VERSION=2024.1.0-amd64 ./build.sh

# Push to registry
PUSH=true ./build.sh
```

### GitHub Actions
Automatic on push to main and tags `v*`. Manual trigger with custom Viseron version.

## Firmware

Includes Coral PCIe firmware from Google Coral repository. Check [Coral releases](https://github.com/google-coral/edgetpu) for updates.

## License

MIT - Same as Viseron