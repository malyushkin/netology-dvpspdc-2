# Ответы

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

Моё устройство на MacOS. Для списка интерфейсов использовал команду `ifconfig -a`:

```bash
roman@MacBook-Pro-admin % ifconfig -a

lo0: flags=8049<UP,LOOPBACK,RUNNING,MULTICAST> mtu 16384
	options=1203<RXCSUM,TXCSUM,TXSTATUS,SW_TIMESTAMP>
	inet 127.0.0.1 netmask 0xff000000
	inet6 ::1 prefixlen 128
	inet6 fe80::1%lo0 prefixlen 64 scopeid 0x1
	nd6 options=201<PERFORMNUD,DAD>
gif0: flags=8010<POINTOPOINT,MULTICAST> mtu 1280
stf0: flags=0<> mtu 1280
en5: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	ether ac:de:48:00:11:22
	inet6 fe80::aede:48ff:fe00:1122%en5 prefixlen 64 scopeid 0x4
	nd6 options=201<PERFORMNUD,DAD>
	media: autoselect (100baseTX <full-duplex>)
	status: active
ap1: flags=8802<BROADCAST,SIMPLEX,MULTICAST> mtu 1500
	options=400<CHANNEL_IO>
	ether b2:9c:4a:c8:b7:5f
	media: autoselect
	status: inactive
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	options=400<CHANNEL_IO>
	ether 90:9c:4a:c8:b7:5f
	inet6 fe80::4da:af2d:b5dd:1c7e%en0 prefixlen 64 secured scopeid 0x6
	inet 192.168.1.143 netmask 0xffffff00 broadcast 192.168.1.255
	nd6 options=201<PERFORMNUD,DAD>
	media: autoselect
	status: active
awdl0: flags=8943<UP,BROADCAST,RUNNING,PROMISC,SIMPLEX,MULTICAST> mtu 1500
	options=400<CHANNEL_IO>
	ether ae:c1:c6:6d:d9:2b
	inet6 fe80::acc1:c6ff:fe6d:d92b%awdl0 prefixlen 64 scopeid 0x7
	nd6 options=201<PERFORMNUD,DAD>
	media: autoselect
	status: active
llw0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	options=400<CHANNEL_IO>
	ether ae:c1:c6:6d:d9:2b
	inet6 fe80::acc1:c6ff:fe6d:d92b%llw0 prefixlen 64 scopeid 0x8
	nd6 options=201<PERFORMNUD,DAD>
	media: autoselect
	status: active
en8: flags=8963<UP,BROADCAST,SMART,RUNNING,PROMISC,SIMPLEX,MULTICAST> mtu 1500
	options=460<TSO4,TSO6,CHANNEL_IO>
	ether 32:3a:62:93:88:44
	media: autoselect <full-duplex>
	status: inactive
en9: flags=8963<UP,BROADCAST,SMART,RUNNING,PROMISC,SIMPLEX,MULTICAST> mtu 1500
	options=460<TSO4,TSO6,CHANNEL_IO>
	ether 32:3a:62:93:88:45
	media: autoselect <full-duplex>
	status: inactive
en3: flags=8963<UP,BROADCAST,SMART,RUNNING,PROMISC,SIMPLEX,MULTICAST> mtu 1500
	options=460<TSO4,TSO6,CHANNEL_IO>
	ether 32:3a:62:93:88:41
	media: autoselect <full-duplex>
	status: inactive
en4: flags=8963<UP,BROADCAST,SMART,RUNNING,PROMISC,SIMPLEX,MULTICAST> mtu 1500
	options=460<TSO4,TSO6,CHANNEL_IO>
	ether 32:3a:62:93:88:40
	media: autoselect <full-duplex>
	status: inactive
...
```

В Linux можно использовать команду `ip -a`.

---

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого? 

Для распознавания соседа используется протокол Link Layer Discovery Protocol (LLDP). В Linux есть пакет `lldpd`. Для практики не с первого раза поднял [новый образ](https://github.com/netology-code/sysadm-homeworks/blob/devsys10/03-sysadmin-07-net/Vagrantfile) Vagrant. На устрйоствах MacOS общая ошибка, решилась с помощью инструкции [тут](https://vc.ru/dev/287597-virtualbox-na-mac-kernel-driver-not-installed-rc-1908-proverennoe-reshenie). 

Далее, на всех трёх машинах выполнил `sudo apt-get upgrade`, затем `sudo apt-get install lldpd`. Запускаю сервис `sudo systemctl enable lldpd && systemctl start lldpd`.

С помощью команды `lldpctl` смотрим раздел `LLDP neighbors`:

```bash
vagrant@netology1:~$ lldpctl

-------------------------------------------------------------------------------
LLDP neighbors:
-------------------------------------------------------------------------------
Interface:    eth1, via: LLDP, RID: 1, Time: 0 day, 00:18:30
  Chassis:
    ChassisID:    mac 08:00:27:73:60:cf
    SysName:      netology2
    SysDescr:     Ubuntu 20.04.3 LTS Linux 5.4.0-80-generic #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021 x86_64
    MgmtIP:       10.0.2.15
    MgmtIP:       fe80::a00:27ff:fe73:60cf
    Capability:   Bridge, off
    Capability:   Router, off
    Capability:   Wlan, off
    Capability:   Station, on
...
```

Например, для машины `netology1` сосед `netology2`.

---

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

Технология VLAN (Virtual Local Area Network). В Linux пакет `vlan`. Для настройки используется файл `/etc/network/interfaces`. На ВМ он пуст:

```bash
vagrant@netology1:~$ cat /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d
```

Пример из сети:

```bash
iface vlan1 inet static
  vlan-raw-device eth0
  address 192.168.1.1
  netmask 255.255.255.0
```

`vlan-raw-device` — указывает на каком сетевом интерфейсе должен создаваться новый интерфейс `vlan1`.

---

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

Типы агрегации интерфейсов в Linux:

* `mode=0 (balance-rr)` — обеспечивает балансировку нагрузки и отказоустойчивость. В данном режиме пакеты отправляются "по кругу" от первого интерфейса к последнему и сначала. Если выходит из строя один из интерфейсов, пакеты отправляются на остальные оставшиеся. При подключении портов к разным коммутаторам, требует их настройки.
* `mode=1 (active-backup)` — при active-backup один интерфейс работает в активном режиме, остальные в ожидающем. Если активный падает, управление передается одному из ожидающих. Не требует поддержки данной функциональности от коммутатора.
* `mode=2 (balance-xor)` — передача пакетов распределяется между объединенными интерфейсами по формуле ((MAC-адрес источника) XOR (MAC-адрес получателя)) % число интерфейсов. Один и тот же интерфейс работает с определённым получателем. Режим даёт балансировку нагрузки и отказоустойчивость.
* `mode=3 (broadcast)` — происходит передача во все объединенные интерфейсы, обеспечивая отказоустойчивость.
* `mode=4 (802.3ad)` — это динамическое объединение портов. В данном режиме можно получить значительное увеличение пропускной способности как входящего так и исходящего трафика, используя все объединенные интерфейсы. Требует поддержки режима от коммутатора, а так же (иногда) дополнительную настройку коммутатора.
* `mode=5 (balance-tlb)` — адаптивная балансировка нагрузки. При balance-tlb входящий трафик получается только активным интерфейсом, исходящий - распределяется в зависимости от текущей загрузки каждого интерфейса. Обеспечивается отказоустойчивость и распределение нагрузки исходящего трафика. Не требует специальной поддержки коммутатора.
* `mode=6 (balance-alb)` — адаптивная балансировка нагрузки, обеспечивает балансировку нагрузки как исходящего (TLB, transmit load balancing), так и входящего трафика (для IPv4 через ARP). Не требует специальной поддержки коммутатором, но требует возможности изменять MAC-адрес устройства.

Пример из сети:

```bash
iface bond0 inet static
        address 10.0.0.11
        netmask 255.255.255.0
        gateway 10.0.0.254
        bond-slaves eth0 eth1
        bond-mode balance-alb # адаптивная балансировка нагрузки
bond-miimon 100
bond-downdelay 200
```

---

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

Для выполнения задачи можно воспользоваться калькулятором подсетей онлайн или пакетом ipcalc. Установим пакет `sudo apt-get install ipcalc` и выполним команду:

```bash
vagrant@vagrant:~$ ipcalc 192.168.1.1/29

Address:   192.168.1.1          11000000.10101000.00000001.00000 001
Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
=>
Network:   192.168.1.0/29       11000000.10101000.00000001.00000 000
HostMin:   192.168.1.1          11000000.10101000.00000001.00000 001
HostMax:   192.168.1.6          11000000.10101000.00000001.00000 110
Broadcast: 192.168.1.7          11000000.10101000.00000001.00000 111
Hosts/Net: 6                     Class C, Private Internet
```

В результате, видимо что: 
* Битовая маска: /29 
* Сетевая маска: 255.255.255.248
* Адрес сети: 192.168.1.1
* Первый хост: 192.168.1.1
* Последний хост: 192.168.1.6
* Широковещательный адрес: 192.168.1.7 
* Всего хостов: 6

```bash
vagrant@vagrant:~$ ipcalc 10.10.10.0/24

Address:   10.10.10.0           00001010.00001010.00001010. 00000000
Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
=>
Network:   10.10.10.0/24        00001010.00001010.00001010. 00000000
HostMin:   10.10.10.1           00001010.00001010.00001010. 00000001
HostMax:   10.10.10.254         00001010.00001010.00001010. 11111110
Broadcast: 10.10.10.255         00001010.00001010.00001010. 11111111
Hosts/Net: 254                   Class A, Private Internet
```

Из сети с маской /24 можно получить 32 /29 подсети. 

Примеры /29 подсетей:
* 10.10.10.0/29 
* 10.10.10.8/29 
* 10.10.10.16/29

---

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

Это частные подсети. Необходимо использовать незанятую: 100.64.0.0 — 100.127.255.255. Маска /10. 

Используем сеть 100.64.0.0/26 (на 62 хоста).

```bash
vagrant@vagrant:~$ ipcalc 100.64.0.0/26

Address:   100.64.0.0           01100100.01000000.00000000.00 000000
Netmask:   255.255.255.192 = 26 11111111.11111111.11111111.11 000000
Wildcard:  0.0.0.63             00000000.00000000.00000000.00 111111
=>
Network:   100.64.0.0/26        01100100.01000000.00000000.00 000000
HostMin:   100.64.0.1           01100100.01000000.00000000.00 000001
HostMax:   100.64.0.62          01100100.01000000.00000000.00 111110
Broadcast: 100.64.0.63          01100100.01000000.00000000.00 111111
Hosts/Net: 62                    Class A
```

---

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

Для Linux: `sudo apt-get install net-tools`. Затем:

* Проверить ARP-таблицу: `arp -n`
* Очистить кеш: `ip neigh flush`
* Удалить один IP: `arp -d <address>`

В Windows проверить APR-таблицу можно командой `arp -a`.