# Настройка Vagrant
Vagrant.configure("2") do |config|

    # Массив с параметрами виртуальных машин
    machines = [
      { name: "jenkins", ip: "10.0.0.96" },
      { name: "slave01", ip: "10.0.0.95" }
    ]
  
    # Плейбук для всех машин
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "vagrant.yml"
    end
  
    # Цикл по массиву машин
    machines.each do |machine|
      # Определяем виртуальную машину
      config.vm.define machine[:name] do |node|
        # Используем CentOS 7 в качестве базового образа
        node.vm.provider "virtualbox" do |vb|
          vb.memory = "4096"
          vb.cpus = 4
        end
        node.vm.box = "centos/9"
        config.vm.box_url = "CentOS-Stream-Vagrant-9-20230704.1.x86_64.vagrant-virtualbox.box"
        # Имя хоста
        node.vm.hostname = machine[:name]
        # IP-адрес
        node.vm.network "public_network", bridge: "eno1", ip: machine[:ip], dev: "eno1"
      end
    end
  end
  
  # https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230704.1.x86_64.vagrant-virtualbox.box
  