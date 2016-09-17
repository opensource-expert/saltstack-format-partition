# saltstack-format-partition
A samble of salt state: to format a partition under debian Jessie and add mountpoint

## Usage

~~~
salt 'minion' state.apply format-partition.install-additional-storage
~~~


## About

This state find a new drive, create a new primary partition using the full space.
Then the partition is formated, and finally the partition is added to `fstab` but not mounted.

`DESTROY_partition.sls` is a tool to destroy what is done above, mainly for testing.

## Snippet

The last step needs to have the partition formated already, so it can't find the
`blkid` of the drive too early. Unfortunately it can't be done during the same
state definition. So I tested two approches, each delays the jinja evaluation of the blkid
when the state is executed, not when the yaml is built for salt.

### seconde state file
~~~yaml
add_fstab:
  module.run:
    - name: state.sls
    - mods: format-partition/.add_fstab
    - unless: grep /home /etc/fstab
~~~

loaded sls file `format-partition.add_fstab.sls`

~~~yaml
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
~~~



### managed file with template
~~~yaml
add_fstab:
  file.append:
    - name: /etc/fstab
    - source: salt://format-partition/files/fstab
    - require:
      - module: mkfs_vdb1
~~~

template file `format-partition/files/fstab`

~~~jinja
{# vim: set ft=jinja: #}
# ceph remote storag, added by salt
UUID="{{ salt['disk.blkid']('/dev/vdb1')['/dev/vdb1']['UUID'] }}" /home ext4 defaults,errors=remount-ro 0 1
~~~
