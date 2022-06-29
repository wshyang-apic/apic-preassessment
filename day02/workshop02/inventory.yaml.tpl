all:
  vars:
    ansible_connection: ssh
    ansible_user: root
    ansible_ssh_private_key_file: /home/fred/.ssh/id_rsa
  hosts:
    %{~ for host_ip in host_ips ~}
    server-1:
      ansible_host: ${host_ip}
    %{~ endfor ~}
