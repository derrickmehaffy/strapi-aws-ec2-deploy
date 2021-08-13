output "strapi_server_public_ip" {
  value = aws_instance.strapi_server.public_ip
}

output "strapi_server_label" {
  value = aws_instance.strapi_server.tags.Name
}

output "strapi_database_public_ip" {
  value = aws_instance.strapi_database.public_ip
}

output "strapi_database_private_ip" {
  value = aws_instance.strapi_database.private_ip
}

output "strapi_database_label" {
  value = aws_instance.strapi_database.tags.Name
}

### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("templates/inventory.tmpl",
    {
      strapi-label   = aws_instance.strapi_server.tags.Name,
      strapi-id      = aws_instance.strapi_server.arn,
      strapi-ip      = aws_instance.strapi_server.public_ip,
      database-label = aws_instance.strapi_database.tags.Name,
      database-id    = aws_instance.strapi_database.arn,
      database-ip    = aws_instance.strapi_database.public_ip,
      # database-pip   = aws_instance.strapi_database.private_ip
    }
  )
  filename = "../ansible/inventory"
}

### Output vars for Ansible
resource "local_file" "Ansible_All_SSH" {
  content = templatefile("templates/ansible_tf_vars.tmpl",
    {
      public-ssh-key  = var.ssh_key
      db-name         = aws_instance.strapi_database.tags.Name
      db-ip           = aws_instance.strapi_database.public_ip
      db-pip          = aws_instance.strapi_database.private_ip
      strapi-app-name = aws_instance.strapi_server.tags.Name
      strapi-url      = element(cloudflare_record.strapi_api_a.*.hostname, 0)
    }
  )
  filename = "../ansible/tf_vars/tf_vars.yml"
}
