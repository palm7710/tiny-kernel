#!/usr/bin/env bash
set -euo pipefail

ROOT="$HOME/workspace/tiny-kernel"
CONTAINER="mikanos-ubuntu"

# 前提チェック 
if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER"; then
    echo "Container '$CONTAINER' is not running. Start it first."
    echo "  docker start -ai $CONTAINER"
    exit 1
fi

# 最新コードを反映
docker exec -it "$CONTAINER" bash -lc "cd /work/tiny-kernel && git pull"

# Docker内でEDK2ビルド（Loader.efi生成）
docker exec -it "$CONTAINER" bash -lc '
set -euo pipefail
cd /root/edk2
source edksetup.sh
build -p MikanLoaderPkg/MikanLoaderPkg.dsc -a X64 -t GCC5
'

# Docker内の成果物を /work(=ホスト共有) のESPへコピー
docker exec -it "$CONTAINER" bash -lc '
set -euo pipefail
mkdir -p /work/esp/EFI/BOOT
cp /root/edk2/Build/MikanLoaderX64/DEBUG_GCC5/X64/Loader.efi /work/esp/EFI/BOOT/BOOTX64.EFI
ls -la /work/esp/EFI/BOOT/BOOTX64.EFI
'

# macOSでGUI起動（QEMUはホストで）
qemu-system-x86_64 \
    -machine q35 \
    -m 1024 \
    -drive if=pflash,format=raw,readonly=on,file=/opt/homebrew/share/qemu/edk2-x86_64-code.fd \
    -drive if=pflash,format=raw,file="$ROOT/ovmf/edk2-x86_64-vars.fd" \
    -drive format=raw,file=fat:rw:"$ROOT/esp"
