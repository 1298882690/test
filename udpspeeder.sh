#!/bin/sh

# 检查root权限
if [ "$(id -u)" != "0" ]; then
    echo "错误：本脚本必须以root权限运行" >&2
    exit 1
fi

# 创建工作目录
work_dir="$(pwd)/udpspeeder"
mkdir -p "$work_dir" || exit 1
cd "$work_dir" || exit 1

# 下载二进制文件
echo "正在下载speederv2_binaries.tar.gz..."
if ! wget -q --show-progress https://github.com/wangyu-/UDPspeeder/raw/master/speederv2_binaries.tar.gz; then
    echo "下载失败，请检查："
    echo "1. 网络连接状态"
    echo "2. GitHub仓库可用性"
    exit 1
fi

# 解压文件
echo -e "\n解压文件中..."
tar xzf speederv2_binaries.tar.gz || {
    echo "解压失败，文件可能损坏"
    exit 1
}

# 显示系统信息
echo -e "\n系统架构：$(uname -m)"
echo "当前目录：$(pwd)"
echo -e "\n解压文件列表："
find . -type f -print

# 用户输入处理
echo -e "\n"
read -rp "请输入要安装的文件路径（相对当前目录）：" target_file

# 验证文件存在性
if [ ! -f "$target_file" ]; then
    echo "错误：文件 $target_file 不存在"
    exit 1
fi

# 安装到系统路径
install_path="/usr/bin/$(basename "$target_file")"
echo -e "\n正在安装到：$install_path"
cp -v "$target_file" "$install_path" || exit 1
chmod 777 "$install_path"

# 验证安装
echo -e "\n安装验证："
if [ -x "$install_path" ]; then
    file "$install_path"
    echo -e "\n安装成功！"
else
    echo "安装验证失败"
    exit 1
fi
