resource "docker_network" "mynet" {
  name = "mynet"
}

resource "docker_volume" "mydb-data" {
  name = "mydb-data"
}

resource "docker_container" "myapp" {
    name  = "myapp"
    image = "stackupiss/northwind-app:v1"
    env = [
        "DB_HOST=mydb",
        "DB_USER=root",
        "DB_PASSWORD=changeit"
    ]
   ports {
        internal = 3000
        external = 8080
    }
    networks_advanced {
            name = "${docker_network.mynet.name}"
    }
    volumes {
        container_path = "/var/lib/mysql"
        volume_name = docker_volume.mydb-data.name
    }
}

resource "docker_container" "mydb" {
    name = "mydb"
    image = "stackupiss/northwind-db:v1"
    ports {
        internal = 3306
        external = 3306
    }
    networks_advanced {
            name = "${docker_network.mynet.name}"
    }
}