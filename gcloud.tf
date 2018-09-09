provider "google" {
    credentials = "${file("account.json")}"
    project     = "<<Your Project Name>>"
    region      = "us-east1"
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20180831"
    }
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
metadata {
 startup-script = <<SCRIPT
${file("${path.module}/setup_influx.sh")}
SCRIPT
    }
  

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
