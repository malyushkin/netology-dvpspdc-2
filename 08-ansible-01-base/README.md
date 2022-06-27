# Практическое задание по теме «Введение в Ansible»

## Подготовка к выполнению

1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

### Ход работы

1. Проверим версию Ansible:

```shell
 ansible --version
ansible [core 2.13.1]
  config file = None
  configured module search path = ['/Users/romanmaliushkin/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /Library/Frameworks/Python.framework/Versions/3.10/lib/python3.10/site-packages/ansible
  ansible collection location = /Users/romanmaliushkin/.ansible/collections:/usr/share/ansible/collections
  executable location = /Library/Frameworks/Python.framework/Versions/3.10/bin/ansible
  python version = 3.10.5 (v3.10.5:f377153967, Jun  6 2022, 12:36:10) [Clang 13.0.0 (clang-1300.0.29.30)]
  jinja version = 3.1.2
  libyaml = True
```

2. Загрузим [playbook](./playbook/).

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

### Ход работы

1. Запустим playbook `site.yml`, используя окружение `inventory/test.yml`:

```shell
ansible-playbook -i inventory/test.yml site.yml 

PLAY [Print os facts] **********************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************
[WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at
/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10, but future installation of another Python interpreter could change the meaning of
that path. See https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]

TASK [Print OS] ****************************************************************************************************************************************
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] **************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *********************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Значение `some_fact` равно `12`.

2. Изменим [значение](playbook/group_vars/all/examp.yml) `some_fact` на `all default fact`.

3. Настроим окружения Centos7 и Ubuntu для проведения испытаний:

* **Centos7**:

```shell
docker run -d -i --name centos7 centos:7 /bin/bash
```

* **Ubuntu** (установим `python3`, так как в [базовой сборке Ubuntu](https://hub.docker.com/_/ubuntu) Python нет):

```
docker run -d -i --name ubuntu ubuntu /bin/bash
docker exec -it ubuntu apt-get update
docker exec -it ubuntu apt-get install python3
```

4. Запустим playbook `site.yml`, используя окружение `inventory/prod.yml`:

```shell
ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] ************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ***********************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Значения `some_fact` для centos7 — `el`, для ubuntu — `deb`.

5. Внесём изменения в [group_vars](playbook/group_vars).

6. Снова запустим playbook `site.yml`:

```shell
ansible-playbook -i inventory/prod.yml site.yml
Vault password:

PLAY [Print os facts] ************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

7. Зашифруем значения `group_vars` с помощью команды `ansible-vault`:

```shell
ansible-vault encrypt group_vars/deb/examp.yml
ansible-vault encrypt group_vars/el/examp.yml
```

Используемый пароль: `netology`.

8. Запустим playbook с флагом `--ask-vault-pass`:

```shell
ansible-playbook -i inventory/prod.yml --ask-vault-pass site.yml
Vault password: 

PLAY [Print os facts] ************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

9. Список плагинов для control node:

```shell
ansible-doc -l -t module

add_host                                                                                 Add a host (and alternatively a group) to the ansible-playbook in-memory inventory  
amazon.aws.aws_az_facts                                                                  Gather information about availability zones in AWS                                  
amazon.aws.aws_az_info                                                                   Gather information about availability zones in AWS                                  
amazon.aws.aws_caller_info                                                               Get information about the user and account being used to make AWS calls             
amazon.aws.aws_s3                                                                        manage objects in S3                                                                
amazon.aws.cloudformation                                                                Create or delete an AWS CloudFormation stack                                        
amazon.aws.cloudformation_info                                                           Obtain information about an AWS CloudFormation stack    
...
```

10. Добавим localhost в [prod.yml](playbook/inventory/prod.yml).

11. Запустим playbook:

```shell
ansible-playbook -i inventory/prod.yml --ask-vault-pass site.yml
Vault password: 

PLAY [Print os facts] ************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]
[WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at /Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10, but future
installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html
for more information.
ok: [localhost]

TASK [Print OS] ******************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] ****************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

## Самоконтроль выполненения задания

1. Где расположен файл с `some_fact` из второго пункта задания?

Файл расположен в [group_vars](playbook/group_vars/all).

2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?

`ansible-playbook -i inventory/test.yml site.yml`

3. Какой командой можно зашифровать файл?

`ansible-vault encrypt <file>`

4. Какой командой можно расшифровать файл?

`ansible-vault decrypt <file>`

5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?

`ansible-vault view <file>`

6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?

`ansible-playbook --ask-vault-pass <yml>`

7. Как называется модуль подключения к host на windows?

[winrm](https://docs.ansible.com/ansible/2.5/plugins/connection/winrm.html)

8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh

`ansible-doc -t connection ssh`

9. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?

```shell
- remote_user
        User name with which to login to the remote server, normally set by the remote_user keyword.
        If no user is supplied, Ansible will let the SSH client binary choose the user as it normally.
        [Default: (null)]
```