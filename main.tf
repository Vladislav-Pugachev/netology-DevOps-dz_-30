provider "yandex" {
  token     = "$TOKEN"
  cloud_id  = "b1gp4sla283e30t0hlep"
  folder_id = "b1g993vs956e0rfvt5bf"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "test" {
  name                      = "test"
  zone                      = "ru-central1-a"
  hostname                  = "test.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = "fd80jfslq61mssea4ejn"
      name        = "root-node01"
      type        = "network-nvme"
      size        = "50"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_test" {
  value = yandex_compute_instance.test.network_interface.0.ip_address
}
output "external_ip_address_test" {
  value = yandex_compute_instance.test.network_interface.0.nat_ip_address
}