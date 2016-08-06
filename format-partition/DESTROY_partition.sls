
# DELETE_PARTITION salt 'minion' partition.rm /dev/vdb 1
# WIPE : salt 'minion' disk.wipe /dev/vdb1

wipe_vdb1:
  cmd.run:
    - name: wipefs -a /dev/vdb1
    - onlyif: blkid /dev/vdb1 | grep ext4


delete_partition:
  module.run:
    - name: partition.rm
    - device: /dev/vdb
    - minor: 1
    - onlyif: fdisk -l /dev/vdb | grep ^/dev/vdb1

/etc/fstab:
  file.line:
    - content: removed
    - match: /home
    - mode: delete

