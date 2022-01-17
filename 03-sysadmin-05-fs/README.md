# Практическое задание по теме «Файловые системы»

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

Разреженные (sparse) файлы — это файлы, которые с большей эффективностью используют пространство файловой системы. Часть цифровой последовательности файла заменена перечнем дыр. Информация об отсутствующих последовательностях располагается в метаданных файловой системы, не занятый высвободившийся объем запоминающего устройства будет использоваться для записи по мере надобности

---

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Рассмотрим вопрос на практике. Для этого создадим новый файл `original_file` и жёсткую ссылку (hard link) `link_file` к нему:

```bash
vagrant@vagrant:~$ touch original_file
vagrant@vagrant:~$ ln original_file link_file
```

Убедимся, что файлы имеют одну айноду (inode):

```bash 
vagrant@vagrant:~$ stat original_file

  File: original_file
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 131094      Links: 2
Access: (0764/-rwxrw-r--)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)
Access: 2021-12-05 17:38:24.905040938 +0000
Modify: 2021-12-05 17:38:24.905040938 +0000
Change: 2021-12-05 17:40:00.857043867 +0000
 Birth: -
 
vagrant@vagrant:~$ stat link_file

  File: link_file
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 131094      Links: 2
Access: (0764/-rwxrw-r--)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)
Access: 2021-12-05 17:38:24.905040938 +0000
Modify: 2021-12-05 17:38:24.905040938 +0000
Change: 2021-12-05 17:40:00.857043867 +0000
 Birth: -
```

Айнода: 131094. Проверим права:

```bash
vagrant@vagrant:~$ ls -l

-rw-rw-r-- 2 vagrant vagrant 0 Dec  5 17:38 link_file
-rw-rw-r-- 2 vagrant vagrant 0 Dec  5 17:38 original_file
```

Они одинаковы. Добавим возможность исполнять файл для пользователя командой `chmod`: 

```bash
vagrant@vagrant:~$ chmod u+x link_file
```

Снова проверим права:

```bash
vagrant@vagrant:~$ ls -l

-rwxrw-r-- 2 vagrant vagrant 0 Dec  5 17:38 link_file
-rwxrw-r-- 2 vagrant vagrant 0 Dec  5 17:38 original_file
```

Как видим право на исполнение (`x`) прописалось в обоих файлах. 

Ответ: файлы, являющиеся жёсткой ссылкой на один объект, не могут иметь разные права доступа и владельца. Права и владелец всегда равны исходному файлу.

---

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu... Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

```bash
vagrant@vagrant:~$ lsblk

NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
sdc                    8:32   0  2.5G  0 disk
```

---

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

Зашёл в sudo `sudo -i`, затем в утилиту `fdisk /dev/sdb`, далее с помощью команд `g`, `n` резметил 2 диска: 

* 2 GB
* 511 M

```bash
...
Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 0B48E999-CC54-9540-AE7A-00F490DE5F62

Device       Start     End Sectors  Size Type
/dev/sdb1     2048 4196351 4194304    2G Linux filesystem
/dev/sdb2  4196352 5242846 1046495  511M Linux filesystem
```

Записываем изменения и выходим из утилиты — `w`.

---

5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

```bash
root@vagrant:~# sfdisk -d /dev/sdb | sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new GPT disklabel (GUID: 0B48E999-CC54-9540-AE7A-00F490DE5F62).
/dev/sdc1: Created a new partition 1 of type 'Linux filesystem' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux filesystem' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: gpt
Disk identifier: 0B48E999-CC54-9540-AE7A-00F490DE5F62

Device       Start     End Sectors  Size Type
/dev/sdc1     2048 4196351 4194304    2G Linux filesystem
/dev/sdc2  4196352 5242846 1046495  511M Linux filesystem

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

---

6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

```bash
root@vagrant:~# mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1

mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? (y/n) y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```

Проверим:

```bash
root@vagrant:~# cat /proc/mdstat

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]
```

---

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

```bash
root@vagrant:~# mdadm --create --verbose /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2

mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
```

Проверим:

```bash
root@vagrant:~# cat /proc/mdstat

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid0 sdc2[1] sdb2[0]
      1041408 blocks super 1.2 512k chunks
```

---

8. Создайте 2 независимых PV на получившихся md-устройствах.

```bash
root@vagrant:~# pvcreate /dev/md0
  Physical volume "/dev/md1" successfully created.
  
root@vagrant:~# pvcreate /dev/md1
  Physical volume "/dev/md0" successfully created.
```

---

9. Создайте общую volume-group на этих двух PV.

```bash
root@vagrant:~# vgcreate vgroup /dev/md0 /dev/md1
  Volume group "vgroup" successfully created
```

---

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

```bash
root@vagrant:~# lvcreate -L 100M vgroup /dev/md1
  Logical volume "lvol0" created.
```

---

11. Создайте `mkfs.ext4` ФС на получившемся LV.

```bash
root@vagrant:~# mkfs.ext4 /dev/vgroup/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

---

12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

```bash
root@vagrant:~# mkdir /tmp/new
root@vagrant:~# mount /dev/vgroup/lvol0 /tmp/new
```

---

13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

```bash
root@vagrant:~# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-12-09 23:56:41--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22836046 (22M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                         100%[===============================================================================>]  21.78M  7.23MB/s    in 3.0s

2021-12-09 23:56:44 (7.23 MB/s) - ‘/tmp/new/test.gz’ saved [22836046/22836046]
```

---

14. Прикрепите вывод `lsblk`.

```bash
root@vagrant:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
  └─md1                9:1    0 1017M  0 raid0
    └─vgroup-lvol0   253:2    0  100M  0 lvm   /tmp/new
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part
  └─md1                9:1    0 1017M  0 raid0
    └─vgroup-lvol0   253:2    0  100M  0 lvm   /tmp/new
```

---

15. Протестируйте целостность файла:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```

```bash
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```

---

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

```bash
root@vagrant:~# pvmove /dev/md1 /dev/md0
  /dev/md1: Moved: 24.00%
  /dev/md1: Moved: 100.00%
```

---

17. Сделайте `--fail` на устройство в вашем RAID1 md.

```bash
root@vagrant:~# mdadm /dev/md0 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
```

---

18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

```bash
root@vagrant:~# dmesg

...
[ 2147.613398] ext4 filesystem being mounted at /tmp/new supports timestamps until 2038 (0x7fffffff)
[ 2664.528337] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
```

---

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```

```bash
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```

---

20. Погасите тестовый хост, `vagrant destroy`.

Done