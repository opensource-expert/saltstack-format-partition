add_fstab:
  mount.mounted:
    - name: /home
    - mount: False
    - device: UUID={{ salt['disk.blkid']('/dev/vdb1')['/dev/vdb1']['UUID'] }}
    - fstype: ext4
    - opts: auto,defaults,errors=remount-ro
    - dump: 0
    - pass_num: 1
    - persist: True
