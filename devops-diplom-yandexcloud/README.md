# Дипломный практикум в YandexCloud

## Подготовка к работе

1. Создадим авторский домен `maliushkin.ru` на [reg.ru](https://www.reg.ru/). Пропишем
   DNS-серверы (`ns1.yandexcloud.net`, `ns2.yandexcloud.net`).

![Reg.ru domain](img/reg-ru-domain.png)

2. Создадим новый workspace `devops-diplom-yandexcloud` в Terraform Cloud.

![Terraform workspace](img/terraform-workspace.png)

## Terraform

Подготовим инфраструктуру в Yandex Cloud при помощи Terraform. Файлы конфигурации доступны по [ссылке](terraform).

**Краткое описание**

* В `provider.tf` добавим конфигурацию провайдера `yandex`:

```terraform
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.75.0"
    }
  }
}

provider "yandex" {
  token     = var.YANDEX_TOKEN
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone      = "ru-central1-a"
}
```

* В `variables.tf` добавим Яндекс токен и идентефикаторы облака:

```terraform
variable "YANDEX_TOKEN" {}

variable "yandex_folder_id" {
  default = "b1gcedqh2opsb3qdvctm"
}

variable "yandex_cloud_id" {
  default = "b1grvrc5vladcufpdjjn"
}

variable "SSH_ID_RSA_PUB" {}
```

* В `main.tf` добавим конфигурацию backend:

```terraform
terraform {
  cloud {
    organization = "maliushkin"

    workspaces {
      name = "devops-diplom-yandexcloud"
    }
  }
}
```

* В `main.tf` добавим настройки всех инстансов. Пример, настройки для сервера `app.maliushkin.domain`:

```terraform
resource "yandex_compute_instance" "app_instance" {
  name = "wordpress"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
```

* В `nextwork.tf` добавим сетевые настройки.
* В `output.tf` добавим вывод настроек доступа и IP-адресов.

### Запуск Terraform

1. Выполним `terraform init`:

```shell
terraform init


Initializing Terraform Cloud...

Initializing provider plugins...
- Finding yandex-cloud/yandex versions matching "0.75.0"...
- Installing yandex-cloud/yandex v0.75.0...
- Installed yandex-cloud/yandex v0.75.0 (self-signed, key ID E40F590B50BB8E40)

...

Terraform Cloud has been successfully initialized!

You may now begin working with Terraform Cloud. Try running "terraform plan" to
see any changes that are required for your infrastructure.

If you ever set or change modules or Terraform Settings, run "terraform init"
again to reinitialize your working directory.
```

2. Выполним `terraform validate`:

```shell
terraform validate

Success! The configuration is valid.
```

3. В Terraform Cloud добавим переменные окружения:

* `TF_VAR_YANDEX_TOKEN` — по [инструкции](https://cloud.yandex.com/en/docs/iam/concepts/authorization/oauth-token).
* `TF_VAR_SSH_ID_RSA_PUB` — копируем из `cat ~/.ssh/id_rsa.pub`.

Выполним `terraform plan`:

```shell
terraform apply --auto-approve

...
Plan: 18 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + app_maliushkin_ru_ip_addr_internal        = (known after apply)
  + db01_maliushkin_ru_ip_addr_internal       = (known after apply)
  + db02_maliushkin_ru_ip_addr_internal       = (known after apply)
  + gitlab_maliushkin_ru_ip_addr_internal     = (known after apply)
  + host_maliushkin_ru_ip_addr_external       = (known after apply)
  + monitoring_maliushkin_ru_ip_addr_internal = (known after apply)
  + ssh_config                                = (known after apply)
```

4. Выполним `terraform apply --auto-approve`.

```shell
terraform apply --auto-approve

...
Apply complete! Resources: 18 added, 0 changed, 0 destroyed.
...
```

После создания инфраструктуры проверим Terraform Cloud:

![Terraform workspace applied](img/terraform-workspace-applied.png)

Так же проверим UI Yandex Cloud:

* **Виртуальные машины**

![Yadnex Cloud VMs](img/yc-vms.png)

* **Зона DNS**

![Yadnex Cloud DNS](img/yc-dns.png)

Инфраструктура **успешно** развёрнута.

## Ansible

Подготовим роли Ansible для созданной инфраструктуры. Файлы конфигурации доступны по [ссылке](ansible).

**Краткое описание**

* В `roles/common` добавим общие сценарии для установки Docker, Docker Compose и Node exporter.
* В `roles/entrance` добавим роль для работы основного сервера.
* В `roles/mysql` добавим роль для работы кластера MySQL.
* В `roles/wordpress` добавим роль для работы WordPress.
* В `roles/monitoring` добавим роль для работы Prometheus, Alert Manager и Grafana.

Для работы Ansible необходимо добавить IP-адреса:

1. Добавим значение output-переменной Terraform в `~/.ssh/config`:

```shell
Host maliushkin.ru
  HostName 51.250.94.37
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
  
Host db01.maliushkin.ru
  HostName 10.100.1.12
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
    ProxyJump ubuntu@51.250.94.37
    ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

Host db02.maliushkin.ru
  HostName 10.100.1.3
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
    ProxyJump ubuntu@51.250.94.37
    ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

Host app.maliushkin.ru
  HostName 10.100.1.26
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
    ProxyJump ubuntu@51.250.94.37
    ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

Host monitoring.maliushkin.ru
  HostName 10.100.1.27
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
    ProxyJump ubuntu@51.250.94.37
    ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

Host gitlab.maliushkin.ru
  HostName 10.100.1.30
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
    ProxyJump ubuntu@51.250.94.37
    ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
```

2. Очистим файл `known_hosts` командой `echo "" > ~/.ssh/known_hosts`

3. Добавим IP-адреса серверов в `variables.yml`:

```shell
app_maliushkin_ru_ip_addr_internal: "10.100.1.26"
db01_maliushkin_ru_ip_addr_internal: "10.100.1.12"
db02_maliushkin_ru_ip_addr_internal: "10.100.1.3"
gitlab_maliushkin_ru_ip_addr_internal: "10.100.1.30"
entrance_maliushkin_ru_ip_addr_external: "51.250.69.226"
monitoring_maliushkin_ru_ip_addr_internal: "10.100.1.27"
```

4. Добавим соответствующие IP-адреса в [конфигурацию](ansible/roles/monitoring/stack/prometheus/prometheus.yml) Prometheus:

```shell
  - job_name: 'entrance-node'
    scrape_interval: 10s
    static_configs:
      - targets: [ '10.100.1.23:9100' ]
      
  - job_name: 'gitlab-node'
    scrape_interval: 10s
    static_configs:
      - targets: [ '10.100.1.22:9100' ]
  
  - job_name: 'monitoring-node'
    scrape_interval: 10s
    static_configs:
      - targets: [ '10.100.1.34:9100' ]
                  
  - job_name: 'wordpress-node'
    scrape_interval: 10s
    static_configs:
      - targets: [ '10.100.1.29:9100' ]

  - job_name: 'db01-node'
    scrape_interval: 10s
    static_configs:
      - targets: [ '10.100.1.30:9100' ]

  - job_name: 'db02-node'
    scrape_interval: 10s
    static_configs:
      - targets: [ '10.100.1.16:9100' ]
```

### Запуск Ansible

1. Запустим [роль](ansible/roles/entrance/tasks/main.yml) для основного сервера:

```shell
ansible-playbook roles/entrance/tasks/main.yml

...
PLAY RECAP ***********************************************************************************************************************************************************************************************
maliushkin.ru         : ok=20   changed=18   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

2. Запустим [роль](ansible/roles/db/tasks/main.yml) кластера MySQL:

```shell
ansible-playbook db/tasks/main.yml

...
PLAY RECAP ***********************************************************************************************************************************************************************************************
db01.maliushkin.ru         : ok=27   changed=21   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
db02.maliushkin.ru         : ok=22   changed=18   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

3. Запустим [роль](ansible/roles/app/tasks/main.yml) для WordPress:

```shell
ansible-playbook app/tasks/main.yml 

...
PLAY RECAP ***********************************************************************************************************************************************************************************************
app.maliushkin.ru          : ok=26   changed=23   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

* Проверим URL [www.maliushkin.ru](https://www.maliushkin.ru):

![Wordpress install](img/wp-install.png)

* Проверим сертификат: 

![Wordpress cert](img/wp-cert.png)

Произведём установку Wordpress:

![Wordpress install 2](img/wp-install-2.png)

![Wordpress main](img/wp-main.png)

4. Запустим [роль](ansible/roles/monitoring/tasks/main.yml) для Prometheus, Alert Manager и Grafana:

```shell
ansible-playbook monitoring/tasks/main.yml 

...
PLAY RECAP ***********************************************************************************************************************************************************************************************
monitoring.maliushkin.ru   : ok=15   changed=13   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

* Проверим URL [prometheus.maliushkin.ru](https://prometheus.maliushkin.ru):

![Prometheus metrics](img/prometheus-metrics.png)

* Проверим URL [alertmanager.maliushkin.ru](https://alertmanager.maliushkin.ru):

![Alertmanager status](img/alertmanager-status.png)

* Проверим URL [grafana.maliushkin.ru](https://grafana.maliushkin.ru):

![Grafana dashboard](img/grafana-dashboard.png)
