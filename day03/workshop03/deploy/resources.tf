data digitalocean_ssh_key apic-virtual-machine {
    name = "fred@ubuntu-s-2vcpu-2gb-sgp1-01"
}

output do_keys {
    value = data.digitalocean_ssh_key.apic-virtual-machine.id
}
output droplet-ipv4 {
    value = digitalocean_droplet.droplet.ipv4_address
}

data digitalocean_droplet_snapshot snapshot {
  name_regex  = "^packer-"
  most_recent = true
}

output do-recent-snapshot {
    value = data.digitalocean_droplet_snapshot.snapshot.name
}

resource digitalocean_droplet droplet {
    name = data.digitalocean_droplet_snapshot.snapshot.name
    image = data.digitalocean_droplet_snapshot.snapshot.id
    size = var.DO_size
    region = var.DO_region
    ssh_keys = [ data.digitalocean_ssh_key.apic-virtual-machine.id ]
}

resource local_file inventory-yaml {
    content = templatefile("./inventory.yaml.tpl", {
        host_ips = [ digitalocean_droplet.droplet.ipv4_address ]
    })
    filename = "post-deploy/inventory.yaml"
    file_permission = "0444"
    provisioner "local-exec" {
        command = "ansible-playbook -i inventory.yaml playbook.yaml"
        working_dir = "post-deploy"
    }
}