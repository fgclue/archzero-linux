# usage: inst-cli [USERNAME] [PASSWORD] [ROOT PASSWORD]
# 	 [KEYBOARD LAYOUT] [TIMEZONE] [DISK] [SWAP]
# 	 [FILESYSTEM] [HOSTNAME]

# Username
# . The user's name.

# Password
# . The user's password.

# Root Password
# . The root password.

# Keyboard Layout
# . The layout for the keyboard
# . example: br-abnt2

# Timezone
# . The users timezone.
# . example: America/Sao_Paulo

# Disk
# . The disk that linux will be
# . installed on.
# . example: /dev/sda

# Swap
# . The size of the swap. (in MB)
# . example: 1024

# Filesystem
# . The filesystem
# . Must be in the name of
# . the mkfs for that filesystem.
# . example: btrfs

# Hostname
# . The hostname for the computer.
# . example: living-room-pc

# Installation:

# Username

username=$1
password=$2
rootpass=$3
keylayout=$4
timezone=$5
diskname=$6
swapsize=$7
filesyst=$8
hostname=$9

# Username
# Password
# Root Password
# Keyboard Layout
# Timezone
# Disk (example: /dev/sda)
# Swap Size
# Filesystem
# Hostname

date=$(date)
loginfo="[$date] zero-inst-cli:"
datecmd="timedatectl set-timezone $timezone"
keyscmd="loadkeys $keylayout"
echo "$loginfo timedatectl set-timezone $timezone"
eval(datecmd)
echo "$loginfo loadkeys $keylayout"
eval(keyscmd)

# TODO: add partitioning

disk1="mkfs.fat -F 32 ${diskname}1"
disk2="mkswap ${diskname}2"
disk3="mkfs.${filesyst} ${diskname}3"
echo "$loginfo ${disk1}"
eval(disk1)
echo "$loginfo ${disk2}"
eval(disk2)
echo "$loginfo ${disk3}"
eval(disk3)

mount1="mount ${diskname}3 /mnt"
mount2="mount --mkdir ${diskname}1 /mnt/boot"
mount3="swapon ${diskname}2"

echo "$loginfo $mount1"
eval(mount1)
echo "$loginfo $mount2"
eval(mount2)
echo "$loginfo $mount3"
eval(mount3)

echo "$loginfo pacstrap -K /mnt base linux linux-firmware vi vim sudo"
pacstrap -K /mnt base linux linux-firmware vi vim sudo

echo "$loginfo genfstab -U /mnt >> /mnt/etc/fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "$loginfo Creating chroot script..."
cd /tmp/
echo "ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime" >> post.sh
echo "hwclock --systohc" >> post.sh

echo "locale-gen" >> post.sh
echo 'echo "LANG=en_US.UTF-8" >> /etc/locale.conf' >> post.sh
echo "echo \"KEYMAP=${keylayout}\" >> /etc/vconsole.conf" >> post.sh
echo "echo \"${hostname}\" >> /etc/hostname" >> post.sh
echo "mkinitcpio -P" >> post.sh

