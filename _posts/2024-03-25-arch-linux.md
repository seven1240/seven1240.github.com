---
layout: post
title: "安装Arch Linux手记"
tags:
  - "操作系统"
category: "操作系统"
description: "之前从没安装过Arch Linux，今天折腾一遍，为避免忘掉，写写笔记。"
---

## 背景

今天尝试安装龙芯版 Linux，本来希望能安装 Debian 版，但只找到[一些文档](https://wiki.debian.org/LoongArch)，没找到可安装版的 ISO。

后来顺着[这篇文章](https://zhuanlan.zhihu.com/p/626169693)找到了[Arch Linux](https://archlinux.org/)，就尝试安装了一下。

安装后发现竟然不会配置网络 😂。而且龙芯版由于是在 QEMU 虚拟机里，运行速度也较慢。所以，我想我需要先学习一下 Arch Linux。

我用的是苹果电脑，ARM 芯片，所以，希望能安装 ARM 版的 Linux，这样运行速才最快。

## 在 OrbStack 上安装 Arch Linux

在[Arch Linux 下载页面](https://archlinux.org/download/)上，可以下载到 x86_64 版本的 ISO，但没找到 ARM 版。后来想起来我用的是[OrbStack](https://orbstack.dev/)，打开图形界面，直接按向导安装了一个 Arch Linux，分分钟就装好了。然后，测试了网络、编译安装 FreeSWITCH 都没有任何问题。

这是一个好的开端，但上述方法安装的 Arch Linux 没有任何网络问题，网络都是自动配置好的，因此，我还需要进一步学习。

## 在 UTM 中安装 Arch Linux

后来在 <https://github.com/JackMyers001/archiso-aarch64/releases> 页面上找到一个 2021 年的 ARM 版 ISO。虽然有些旧，但学习应该够用了。

打开我的[UTM](https://mac.getutm.app/)虚拟机，我创建了一个新的 ARM 机器，使用上面下载的 ISO 就开始安装了。

Arch Linux 与我熟悉的 Debian 和 CentOS 安装步骤有很大不同！

Arch Linux ISO 启动后，进入一个 Shell 环境，竟然没有任何安装向导。还好我的 Linux 基础比较扎实，顺着教程也一步一步安装完成了。过程主要参考了[这个页面](https://wiki.archlinuxcn.org/wiki/安装指南)。

从光盘启动虚拟机。`fdisk -l`找到我的硬盘，看起来是`/dev/vda`。然后，使用`fdisk /dev/vda`命令分区。首先输入`g`，告诉硬盘使用 GPT 分区格式。然后，创建 3 个分区，分别是：

- `vda1`：UEFI 分区，1G
- `vda2`：Swap 分区，2G
- `vda3`：根分区，剩余空间

格式化分区：

```sh
mkfs.fat -F 32 /dev/vda1
mkswap /dev/vda2
mkfs.ext4 /dev/vda3
```

挂载分区：

```sh
mount /dev/vda3 /mnt
mkdir /mnt/boot
mount /dev/vda1 /mnt/boot
```

安装系统。

```sh
pacstrap -K /mnt base linux linux-firmware
```

文档上说要使用`-K`，但我的镜像好像比较旧，去掉`-K`才安装成功。

生成`fstab`文件：

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

`chroot`到新安装的系统：

```sh
arch-chroot /mnt
```

设置 root 密码：

```sh
passwd
```

安装引导程序，先安装`grub`：

```sh
pacman -S grub efibootmgr
```

我使用 UEFI 启动，将`grub`安装到 UEFI 分区：

```sh
grub-install --target=arm64-efi --efi-directory=/root/EFI --removable
```

有人说这个`--removable`很有用，我没有确认。

生成`grub`配置文件：

```sh
grub-mkconfig -o /boot/grub/grub.cfg
```

装完后，很重要的一步，安装`dhclient`，以便能使用 DHCP 获取 IP 地址：

```sh
pacman -S dhclient
```

其他一些设置好像无关紧要了。`exit`退出`chroot`环境，弹出光盘，`reboot`重启就可以进入 Arch Linux 了。

进入后，如果没有网络，手工执行`dhclient`，就可以获取 IP 地址了。

Linux 能上网以后，就谁都不怕了，我可以继续安装其他软件了。

## 龙芯版 Arch Linux

通过上述折腾，也查了一些文档，总算基本上了解了 Arch Linux。谁让咱还有些 Linux 功底呢。

我推测，龙芯版 Linux 默认没有安装`dhclient`，才导致我上不了网。重装一遍。

我的 UTM 不支持龙芯，因此，我只能使用 QEMU 了。

下载：

- 固件：<https://mirrors.pku.edu.cn/loongarch/archlinux/images/QEMU_EFI_7.2.fd>
- ISO：<https://mirrors.pku.edu.cn/loongarch/archlinux/iso/latest/archlinux-loong64.iso>

创建一个硬盘：

```sh
qemu-img create -f qcow2 hd.qcow2 100G
```

启动虚拟机：

```sh
qemu-system-loongarch64 \
    -m 5G \
    -cpu la464-loongarch-cpu \
    -machine virt \
    -smp 4 \
    -bios QEMU_EFI_7.2.fd \
    -serial stdio \
    -device virtio-gpu-pci \
    -net nic -net user \
    -device nec-usb-xhci,id=xhci,addr=0x1b \
    -device usb-tablet,id=tablet,bus=xhci.0,port=1 \
    -device usb-kbd,id=keyboard,bus=xhci.0,port=2 \
    -cdrom archlinux-loong64.iso \
    -boot once=d \
    -hda hd.qcow2
```

令人惊喜的是，龙芯版的 ISO 竟然有一个安装向导。虽然不像 Debian 那么直观。

顺着安装向导，我做了如下设置：

- 镜像：选 China
- 磁盘配置：使用最佳，选了`/dev/vdb`，它是我的硬盘。
- 设置 root 密码。
- 附加软件包：当然选了`dhclient`。
- 网络配置：将 ISO 中的配置复制到安装中。这个很有用。

其他的选择可以使用默认值，也可以自己定制。接下来按向导进行安装就可以了。

安装完成后，重启，进入 Shell，显示如下：

```sh
# uname -a
Linux archlinux 6.7.0-6 #1 SMP PREEMPT Tue, 09 Jan 2024 11:51:31 +0000 loongarch64 GNU/Linux
```

我是使用如下命令启动 QEMU 的，通过将`22`端口映射为`2022`，可以在外面连接虚拟机中的 Linux。

```sh
qemu-system-loongarch64 \
    -m 5G \
    -cpu la464-loongarch-cpu \
    -machine virt \
    -smp cpus=8,sockets=1,cores=8,threads=1 \
    -bios media/QEMU_EFI_7.2.fd \
    -serial stdio \
    -device virtio-gpu-pci \
    -net nic -net user,hostfwd=tcp::2022-:22 \
    -device nec-usb-xhci,id=xhci,addr=0x1b \
    -device usb-tablet,id=tablet,bus=xhci.0,port=1 \
    -device usb-kbd,id=keyboard,bus=xhci.0,port=2 \
    -hda hd.qcow2
```

连网，就可以继续安装其他软件了。我安装了 Git、Vim 等，现在正在编译 FreeSWITCH。目测没啥问题，就是在 ARM 上模拟`loongarch64` CPU，超级慢。

不知道是否有人能贡献个真正的 CPU。后续，我会写写在龙芯和 Arch Linux 上安装 FreeSWITCH 的过程。

最近有人批评我写的文章比较水。流水账嘛，水一点就水一点好了 😂。

如果有人知道去哪里下载龙芯版的 UOS，也欢迎留言告诉我：<https://www.cnblogs.com/dujinfang/p/18095472> 。

本文永久链接：<https://www.dujinfang.com/2024/03/25/arch-linux.html> 。
