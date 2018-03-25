#!/usr/bin/env bash
set -e

echo "Grabbing IPs..."
PRIVATE_IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
PUBLIC_IP=$PRIVATE_IP

function installDependencies() {
  echo "Installing dependencies..."
  apt-get -qq update &>/dev/null
  apt-get -yqq install unzip iputils-ping dnsutils &>/dev/null
}

function installDocker() {
  echo "Installing Docker..."
  apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D &>/dev/null
  apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' &>/dev/null
  apt-get update &>/dev/null
  apt-get install -y docker-engine &>/dev/null
  systemctl start docker
}

function installConsul() {
  echo "Fetching Consul..."
  cd /tmp
  curl -sLo consul.zip https://releases.hashicorp.com/consul/$1/consul_$1_linux_amd64.zip
  
  echo "Installing Consul..."
  apt-get install dnsmasq -y &>/dev/null
  echo "server=/consul/127.0.0.1#8600" > /etc/dnsmasq.d/10-consul
  echo "nameserver 8.8.8.8" >> /etc/resolv.conf
  cat /etc/resolv.conf | sed "s/127.0.0.11/127.0.0.1/g" > /etc/resolv.conf.sed
  cp /etc/resolv.conf.sed /etc/resolv.conf

unzip consul.zip >/dev/null
  chmod +x consul
  mv consul /usr/local/bin/consul

  # Setup Consul
  mkdir -p /mnt/consul
  mkdir -p /etc/consul.d
  tee /etc/consul.d/config.json > /dev/null <<EOF
  ${consul_config}
EOF
  
  tee /etc/systemd/system/consul.service > /dev/null <<"EOF"
  [Unit]
  Description = "Consul"
  
  [Service]
  # Stop consul will not mark node as failed but left
  KillSignal=INT
  ExecStart=/usr/local/bin/consul agent -config-dir="/etc/consul.d"
  Restart=always
  ExecStopPost=sleep 5
EOF
}

function installVault() {
  echo "Fetching Vault..."
  cd /tmp
  curl -sLo vault.zip https://releases.hashicorp.com/vault/$1/vault_$1_linux_amd64.zip

  echo "Installing Vault..."
  unzip vault.zip >/dev/null
  chmod +x vault
  mv vault /usr/local/bin/vault

  # Setup Vault
  mkdir -p /mnt/vault
  mkdir -p /etc/vault.d
  tee /etc/vault.d/config.json > /dev/null <<EOF
  ${vault_config}
EOF

  tee /etc/systemd/system/vault.service > /dev/null <<"EOF"
  [Unit]
  Description = "Vault"

  [Service]
  # Stop vault will not mark node as failed but left
  KillSignal=INT
  Environment=GOMAXPROCS=nproc
  ExecStart=/usr/local/bin/vault server -config="/etc/vault.d"
  Restart=always
  ExecStopPost=sleep 5
EOF
}

function installNomad() {
  echo "Fetching Nomad..."
  cd /tmp
  curl -sLo nomad.zip https://releases.hashicorp.com/nomad/${nomad_version}/nomad_${nomad_version}_linux_amd64.zip
  
  echo "Installing Nomad..."
  unzip nomad.zip >/dev/null
  chmod +x nomad
  mv nomad /usr/local/bin/nomad
  
  # Setup Nomad
  mkdir -p /mnt/nomad
  mkdir -p /etc/nomad.d
  tee /etc/nomad.d/config.hcl > /dev/null <<EOF
  ${nomad_config}
EOF
  
  tee /etc/systemd/system/nomad.service > /dev/null <<"EOF"
  [Unit]
  Description = "Nomad"
  
  [Service]
  # Stop consul will not mark node as failed but left
  KillSignal=INT
  ExecStart=/usr/local/bin/nomad agent -config="/etc/nomad.d"
  Restart=always
  ExecStopPost=sleep 5
EOF
}

function installHashiUI() {
  echo "Fetching hashi-ui..."
  cd /tmp
  curl -sLo hashi-ui \
    https://github.com/jippi/hashi-ui/releases/download/v${hashiui_version}/hashi-ui-linux-amd64
  chmod +x hashi-ui
  mv hashi-ui /usr/local/bin/hashi-ui
  
  echo "Installing hashi-ui..."
  tee /etc/systemd/system/hashi-ui.service > /dev/null <<EOF
  [Unit]
  description="Hashi UI"
  
  [Service]
  KillSignal=INT
  ExecStart=/usr/local/bin/hashi-ui --consul-enable --nomad-enable --nomad-address http://$PRIVATE_IP:4646
  Restart=always
  RestartSec=5
  ExecStopPost=sleep 10
EOF
}


# Install software
installDependencies

if [[ ${consul_enabled} == 1 ]]; then
installConsul ${consul_version}
fi

if [[ ${vault_enabled} == 1 ]]; then
installVault ${vault_version}
fi

if [[ ${nomad_enabled} == 1 ]]; then
  installNomad ${nomad_version}
fi

if [[ ${nomad_enabled} == 1 && ${nomad_type} == "client" ]]; then
  installDocker
fi

if [[ ${hashiui_enabled} == 1 ]]; then
  installHashiUI ${hashiui_version}
fi


# Start services
systemctl daemon-reload

if [[ ${consul_enabled} == 1 ]]; then
  #echo "export CONSUL_RPC_ADDR=$PRIVATE_IP:8400" | tee --append /root/.bashrc
  #echo "export CONSUL_HTTP_ADDR=$PRIVATE_IP:8500" | tee --append /root/.bashrc
  systemctl enable consul.service
  systemctl start consul.service
fi

if [[ ${nomad_enabled} == 1 ]]; then
  echo "export NOMAD_ADDR=http://$PRIVATE_IP:4646" | tee --append /root/.bashrc
  systemctl enable nomad.service
  systemctl start nomad.service
fi

if [[ ${vault_enabled} == 1 ]]; then
  echo "export VAULT_ADDR=http://$PRIVATE_IP:8200" | tee --append /root/.bashrc
  systemctl enable vault.service
  systemctl start vault.service
fi

if [[ ${hashiui_enabled} == 1 ]]; then
  systemctl enable hashi-ui.service
  systemctl start hashi-ui.service
fi
