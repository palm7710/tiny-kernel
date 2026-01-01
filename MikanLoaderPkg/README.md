# mikanos

- Ubuntu 環境 実行方法（MacOS）

```bash
# docker run（今後の再開方法）
docker start -ai mikanos-ubuntu

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
ln -s /work/MikanLoaderPkg ./
ls MikanLoaderPkg/Main.c

# Loader.efi をビルド
cd $HOME/edk2
source edksetup.sh

build \
  -p MikanLoaderPkg/MikanLoaderPkg.dsc \
  -a X64 \
  -t GCC5
```
