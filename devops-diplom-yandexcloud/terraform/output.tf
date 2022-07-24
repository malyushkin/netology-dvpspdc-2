output "host_maliushkin_ru_ip_addr_external" {
  value = yandex_compute_instance.entrance_instance.network_interface.0.nat_ip_address
}

output "db01_maliushkin_ru_ip_addr_internal" {
  value = yandex_compute_instance.db01_instance.network_interface.0.ip_address
}

output "db02_maliushkin_ru_ip_addr_internal" {
  value = yandex_compute_instance.db02_instance.network_interface.0.ip_address
}

output "app_maliushkin_ru_ip_addr_internal" {
  value = yandex_compute_instance.app_instance.network_interface.0.ip_address
}

output "monitoring_maliushkin_ru_ip_addr_internal" {
  value = yandex_compute_instance.monitoring_instance.network_interface.0.ip_address
}

output "gitlab_maliushkin_ru_ip_addr_internal" {
  value = yandex_compute_instance.gitlab_instance.network_interface.0.ip_address
}

output "ssh_config" {
  value = <<-EOT

  Host db01.maliushkin.ru
    HostName ${yandex_compute_instance.db01_instance.network_interface.0.ip_address}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
      ProxyJump ubuntu@${yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host db02.maliushkin.ru
    HostName ${yandex_compute_instance.db02_instance.network_interface.0.ip_address}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
      ProxyJump ubuntu@${yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host app.maliushkin.ru
    HostName ${yandex_compute_instance.app_instance.network_interface.0.ip_address}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
      ProxyJump ubuntu@${yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host monitoring.maliushkin.ru
    HostName ${yandex_compute_instance.monitoring_instance.network_interface.0.ip_address}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
      ProxyJump ubuntu@${yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host gitlab.maliushkin.ru
    HostName ${yandex_compute_instance.gitlab_instance.network_interface.0.ip_address}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
      ProxyJump ubuntu@${yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  EOT
}
