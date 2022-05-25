resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

#### 1 vm
resource "yandex_compute_instance" "vm-1" {
  name        = "jenkins"
  description = "VM for jenkins"

  resources {
    cores         = 2   # vCPU
    memory        = 2   # RAM
    core_fraction = 20  # vCPU 20%
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size = 6  # memory
    }
  }

  scheduling_policy {
    preemptible = false
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
  }

  provisioner "remote-exec" {
    inline = ["echo 'Jenkins-Im ready!'"]
  }

}

#### 2 vm
resource "yandex_compute_instance" "vm-2" {
  name        = "webserver"
  description = "VM for project"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size = 6  # memory
    }
  }

  scheduling_policy {
    preemptible = false
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
  }


  provisioner "remote-exec" {
    inline = ["echo 'Webserver-Im ready!'"]
  }

#    provisioner "local-exec" {
#    command = "ansible-playbook -u ubuntu -i '${self.network_interface.0.nat_ip_address},' --private-key ~/.ssh/id_rsa ansible/provision.yml"
#  }
}

resource "local_file" "inventory" {
  filename = "ansible/hosts"
  file_permission = "0644"
  content = templatefile("inventory.ini",
    {
      jenkins = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address,
      webserver = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
    }
  )

  provisioner "local-exec" {
    command = "ansible-playbook ansible/jenkins.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook ansible/provision.yml"
  }

}
