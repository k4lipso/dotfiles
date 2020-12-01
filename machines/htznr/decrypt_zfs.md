#Decrypting:

zpool import # lists pools
zpool import rpool # import pool with name rpool
zfs load-key rpool # encrypts pool

#mounting:

mount -t zfs rpool/root/nixos /mnt
mount -t zfs rpool/home /mnt/home
mount /dev/sdb3 /mnt/boot/
