# 🚀 Deploy Multinode OpenStack com Kolla-Ansible

**Versão organizada — 2026**

---

# 📑 Sumário

1. Pré-requisitos
2. Preparação das máquinas
3. Criação do usuário `deploy`
4. Configuração do nó principal (controller)
5. Configuração de SSH entre os nós
6. Configuração de sudo sem senha
7. Inventário multinode
8. Configuração do `globals.yml`
9. Preparação de storage (Cinder LVM)
10. Certificados (Octavia)
11. Deploy do cluster
12. Pós-deploy
13. Acesso ao Horizon
14. Troubleshooting comum
15. Checklist final

---

# 1️⃣ Pré-requisitos

* Todas as máquinas com:

  * Ubuntu Server 24.04 LTS
  * Rede configurada
* Comunicação entre os nós funcionando (ping OK)
* Acesso SSH entre máquinas

---

# 2️⃣ Preparação inicial (TODOS OS NÓS)

```bash
sudo apt update && sudo apt upgrade -y
```

---

# 3️⃣ Criar usuário `deploy` (TODOS OS NÓS)

```bash
sudo useradd -m -s /bin/bash deploy
sudo usermod -aG sudo deploy
```

---

# 4️⃣ Configuração do nó principal (CONTROLLER)

## Instalar dependências

```bash
sudo apt update
sudo apt install -y git python3-dev libffi-dev gcc libssl-dev libdbus-glib-1-dev python3-venv
```

---

## Criar ambiente virtual

```bash
python3 -m venv /opt/kolla-venv
sudo chown -R deploy:deploy /opt/kolla-venv
source /opt/kolla-venv/bin/activate
```

---

## Instalar Kolla-Ansible

```bash
pip install -U pip
pip install git+https://opendev.org/openstack/kolla-ansible@master
```

---

## Criar estrutura de config

```bash
mkdir -p /etc/kolla
chown $USER:$USER /etc/kolla
cp -r /opt/kolla-venv/share/kolla-ansible/etc_examples/kolla/* /etc/kolla
```

---

## Instalar dependências do Ansible

```bash
kolla-ansible install-deps
```

---

# 5️⃣ Configuração de SSH (SEM SENHA)

## Método manual (1 nó)

No controller:

```bash
cat ~/.ssh/id_ed25519.pub
```

No outro nó:

```bash
mkdir -p /home/deploy/.ssh
nano /home/deploy/.ssh/authorized_keys
```

Cole a chave pública.

Permissões:

```bash
chown -R deploy:deploy /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
chmod 600 /home/deploy/.ssh/authorized_keys
```

---

## Método automático (vários nós)

```bash
for i in 21 22 23; do
  ssh root@192.168.201.$i "mkdir -p /home/deploy/.ssh"
  cat ~/.ssh/id_ed25519.pub | ssh root@192.168.201.$i "cat >> /home/deploy/.ssh/authorized_keys"
  ssh root@192.168.201.$i "chown -R deploy:deploy /home/deploy/.ssh && chmod 700 /home/deploy/.ssh && chmod 600 /home/deploy/.ssh/authorized_keys"
done
```

---

# 6️⃣ Configurar SUDO sem senha (ESSENCIAL)

```bash
ssh -t inovatech@192.168.201.21 \
"echo 'deploy ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/deploy"
```

---

## Script para múltiplos nós

```bash
NODES="192.168.201.21 192.168.201.22"

for IP in $NODES; do
  ssh -t inovatech@$IP \
  "echo 'deploy ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/deploy"
done
```

---

## Teste (CRÍTICO)

```bash
ssh deploy@192.168.201.21 "sudo id"
```

Deve retornar:

```
uid=0(root)
```

---

# 7️⃣ Inventário multinode

Arquivo: `~/multinode`

```ini
[control]
dell1

[network]
dell1

[compute]
node1
node2

[storage]
dell1

[monitoring]
dell1

[deployment]
localhost ansible_connection=local
```

---

# 8️⃣ globals.yml

```yaml
kolla_base_distro: "ubuntu"
network_interface: "eno1"
neutron_external_interface: "eno2"
kolla_internal_vip_address: "192.168.201.30"

enable_openstack_core: true

enable_cinder: true
enable_cinder_backend_lvm: true
enable_cinder_backend_iscsi: "{{ enable_cinder_backend_lvm | bool }}"
cinder_enabled_backends: "lvm"

enable_grafana: true
enable_prometheus: true

enable_magnum: "yes"
enable_barbican: "yes"
enable_octavia: "yes"
enable_designate: "yes"
```

---

# 9️⃣ Storage (Cinder LVM)

⚠️ O controller também precisa do volume group

```bash
lsblk
sudo wipefs -a /dev/sdb

sudo pvcreate /dev/sdb
sudo vgcreate cinder-volumes /dev/sdb
sudo vgs
```

---

# 🔟 Certificados (Octavia)

```bash
kolla-ansible octavia-certificates -i ~/multinode
```

---

# 11️⃣ Deploy

Ativar venv:

```bash
source /opt/kolla-venv/bin/activate
```

Executar:

```bash
kolla-ansible bootstrap-servers -i ~/multinode
kolla-ansible prechecks -i ~/multinode
kolla-ansible deploy -i ~/multinode
kolla-ansible post-deploy -i ~/multinode
```

---

# 12️⃣ Pós-deploy

```bash
pip install python-openstackclient
source /etc/kolla/admin-openrc.sh
openstack service list
```

---

# 13️⃣ Horizon

Acessar:

```
http://192.168.201.30
```

Usuário:

```
admin
```

Senha:

```bash
cat /etc/kolla/passwords.yml | grep keystone_admin_password
```

---

# 14️⃣ Troubleshooting

### Cinder reclamando de VG

→ Criar VG também no controller

---

### SSH pedindo senha

→ Permissões ou chave errada

---

### Sudo pedindo senha

→ `/etc/sudoers.d/deploy` não criado corretamente

---

### Prechecks falhando

→ Corrigir antes do deploy

---

# 15️⃣ ✅ Checklist final

* [ ] SSH sem senha funcionando
* [ ] `sudo id` sem senha funcionando
* [ ] Inventário correto
* [ ] Interfaces corretas (`eno1`, `eno2`)
* [ ] VIP livre
* [ ] Volume group criado
* [ ] Certificados Octavia gerados
* [ ] Prechecks sem erro

---

# 🔍 Validação final

Antes de considerar esse processo fechado:

* Quantos nós existem no cluster?
* Todos são bare metal?
* Interfaces estão corretas?
* Pretende migrar storage para Ceph futuramente?

---
