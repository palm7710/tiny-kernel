# mikanos

- Ubuntu 環境 実行方法（MacOS）

```bash
# docker run（今後の再開方法）
docker start -ai mikanos-ubuntu
# または
docker exec -it mikanos-ubuntu bash

# Ubuntuコンテナを起動（初回）
mkdir -p ~/workspace/tiny-kernel
docker run -it --name mikanos-ubuntu \
  --platform=linux/amd64 \
  -v ~/workspace/tiny-kernel:/work \
  -v ~/workspace/mikanos-home:/root \
  -w /work \
  ubuntu:22.04 bash

# Ubuntu 内（初回）
apt update
apt install -y git sudo python3 python3-pip ansible

# mikanos-build を取得して環境構築（初回）
cd /work
git clone https://github.com/uchan-nos/mikanos-build.git osbook
cd /work/osbook/devenv
ansible-playbook -i ansible_inventory ansible_provision.yml

# リポジトリ をビルド対象にする（初回）
cd $HOME/edk2
ln -s /work/tiny-kernel/MikanLoaderPkg ./
ls MikanLoaderPkg/Main.c

# Loader.efi をビルド
cd $HOME/edk2
source edksetup.sh
build -p MikanLoaderPkg/MikanLoaderPkg.dsc -a X64 -t GCC5

# 成功確認
ls Build/MikanLoaderX64/DEBUG_GCC5/X64/Loader.efi

```

# QEMU + OVMF で起動して “Hello, Mikan World!” を表示させる

```bash
# コンテナ起動
docker start -ai mikanos-ubuntu
# または
docker exec -it mikanos-ubuntu bash

# OVMF（UEFIファーム）を用意
apt update
apt install -y ovmf qemu-system-x86

# FATイメージ（UEFIが読むディスク）を作る
mkdir -p /work/esp/EFI/BOOT
cp /root/edk2/Build/MikanLoaderX64/DEBUG_GCC5/X64/Loader.efi /work/esp/EFI/BOOT/BOOTX64.EFI

# GUIなしで起動
cp /usr/share/OVMF/OVMF_VARS.fd /work/OVMF_VARS.fd

# GUIありで起動（MacOSは、コンテナ外が現実的です）
qemu-system-x86_64 \
  -machine q35 \
  -m 1024 \
  -drive if=pflash,format=raw,readonly=on,file=/opt/homebrew/share/qemu/edk2-x86_64-code.fd \
  -drive if=pflash,format=raw,file=$HOME/workspace/tiny-kernel/ovmf/edk2-x86_64-vars.fd \
  -drive format=raw,file=fat:rw:$HOME/workspace/tiny-kernel/esp

```
