# Ответы

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

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

8. Создайте 2 независимых PV на получившихся md-устройствах.

9. Создайте общую volume-group на этих двух PV.

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

11. Создайте `mkfs.ext4` ФС на получившемся LV.

12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

14. Прикрепите вывод `lsblk`.

15. Протестируйте целостность файла:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

17. Сделайте `--fail` на устройство в вашем RAID1 md.

18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```

20. Погасите тестовый хост, `vagrant destroy`.