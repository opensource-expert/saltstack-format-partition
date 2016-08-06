# from doc : https://www.ovh.com/fr/g2181.Commande_et_utilisation_d_un_disque_additionnel#utilisation_linux
#

detect_new_disk:
  cmd.run:
    - name: fdisk -l | grep "^Disk /dev/vdb:"
    - unless: fdisk -l | grep /dev/vdb1

create_partition_disk:
  module.run:
    - name: partition.mkpart
    - device: /dev/vdb
    # using percent permit to have maximum size
    - start: 0%
    - end: 100%
    - part_type: primary
    - unless: blkid /dev/vdb1

mkfs_vdb1:
   module.run:
    - name: extfs.mkfs
    - device: /dev/vdb1 
    - fs_type: ext4 
    - unless: blkid /dev/vdb1 | grep ext4

add_fstab:
  module.run:
    - name: state.sls
    - mods: format-partition.add_fstab
    - unless: grep /home /etc/fstab

#add_fstab:
#  file.append:
#    - name: /etc/fstab
#    - source: salt://format-partition/files/fstab
#    - require:
#      - module: mkfs_vdb1
