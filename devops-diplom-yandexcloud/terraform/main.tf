terraform {
  cloud {
    organization = "maliushkin"

    workspaces {
      name = "devops-diplom-yandexcloud"
    }
  }
}

resource "yandex_compute_instance" "nat_instance" {
  name     = "nat"
  hostname = "nat.maliushkin.ru"
  zone     = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd84mnpg35f7s7b0f5lg"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_vpc_subnet.id
    nat       = true
  }

  metadata = {
    test     = "test_str"
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

resource "yandex_compute_instance" "entrance_instance" {
  name = "main"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

resource "yandex_compute_instance" "db01_instance" {
  name = "mysql-master"
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
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

resource "yandex_compute_instance" "db02_instance" {
  name = "mysql-slave"
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
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

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
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

resource "yandex_compute_instance" "monitoring_instance" {
  name = "monitoring"
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
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

resource "yandex_compute_instance" "gitlab_instance" {
  name = "gitlab"
  zone = "ru-central1-a"

  resources {
    cores  = 8
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 30
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

resource "yandex_compute_instance" "runner_instance" {
  name = "runner"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 30
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}