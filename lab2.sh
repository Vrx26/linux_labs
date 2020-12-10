fdisk /dev/sdb
# n (new partition)
# p (primary partition)
# 1 (partition number)
# 2048 (first sector)
# +300M (last partition)
# w (write)

blkid /dev/sdb1 > uuid

mkfs.ext4 -b 4096 /dev/sdb1
dumpe2fs -h /dev/sdb1
tune2fs -c 2 -i 2m /dev/sdb1
mkdir /mnt/newdisk
mount /dev/sdb1 /mnt/newdisk/
mkdir /mnt/newdisk/catalog
ln -s /mnt/newdisk/ disklink
echo "/dev/sdb1 /mnt/newdisk ext4 rw,noatime,noexec 0 0" >> /etc/fstab

fdisk /dev/sdb
# d (delete partition)
# n > p > 1 > 2048 > +350M > w

umount /mnt/newdisk && e2fsck -fn /dev/sdb1

fdisk /dev/sdb
# n > p > > > +12M > w

tune2fs -O ^has_journal /dev/sdb1
mke2fs -O journal_dev /dev/sdb2
tune2fs -j -J device=/dev/sdb2 /dev/sdb1
mount /dev/sdb1 /mnt/newdisk/

fdisk /dev/sdb
# n > p > > > +100M > n > p > > +100M > w
pvcreate /dev/sdb3 /dev/sdb4
vgcreate grp1 /dev/sdb3/ /dev/sdb4
lvcreate -l 100%FREE -n lvl1 grp1
mkfs.ext4 -b 4096 /dev/grp1/lvl1
mkdir /mnt/supernewdisk
mount /dev/grp1/lvl1 /mnt/supernewdisk/

mkdir /mnt/share
mount.nfs 192.168.1.12:/home/oukli26/Documents/share /mnt/share/ -o v3
echo "192.168.1.12:/home/oukli26/Documents/share /mnt/share nfs noexec 0 0" >> /etc/fstab
