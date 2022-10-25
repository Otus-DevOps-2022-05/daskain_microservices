terraform {
 required_providers {
   yandex = {
     source = "yandex-cloud/yandex"
   }
 }
 required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_vpc_network" "k8s-net" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s-subnet" {
  name           = "k8s-subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k8s-net.id
  v4_cidr_blocks = [var.ip_range]

}

data "yandex_compute_image" "ubuntu-image" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "k8s" {
  name  = "k8s-${count.index}"
  count = var.instance_count
  hostname = "k8s-${count.index}"

  metadata = {
    ssh-keys = "kuber:${file(var.public_key_path)}"
  }

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-image.image_id
      size     = 40
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s-subnet.id
    nat       = true
  }

  connection {
    type  = "ssh"
    host  = self.network_interface.0.nat_ip_address
    user  = "kuber"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }

}
