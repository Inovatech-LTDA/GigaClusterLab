![alt text](images/head.jpg)
# 🖥️ Inovatech Cluster — Infraestrutura Universitária

> Projeto de infraestrutura enterprise doada e reativada pelo grupo **Inovatech** da universidade.  
> Hardware real, ambiente profissional, propósito acadêmico.

---

## 📦 Inventário de Hardware

### Dell PowerEdge C6100 — Cluster Principal
> 1 chassi 2U com 4 nós independentes

| Nó | CPU | RAM | Armazenamento |
|----|-----|-----|---------------|
| SRV-1 | 2× Intel Xeon X5650 | 64 GB DDR3 | 5TB total |
| SRV-2 | 2× Intel Xeon X5650 | 64 GB DDR3 | 5TB total |
| SRV-3 | 2× Intel Xeon X5650 | 64 GB DDR3 | 5TB total |
| SRV-4 | 2× Intel Xeon X5650 | 64 GB DDR3 | 5TB total |

**Total: 256 GB RAM | ~20 TB bruto**

---

### HP ProLiant BL460c Gen8 — Expansão Futura
> 8 blades em chassi c7000

| Spec | Por blade | Total |
|------|-----------|-------|
| CPU | 2× Intel Xeon E5-2650 | 16 processadores |
| RAM | 128 GB | 1 TB |
| Chassi | HP c7000 | ✅ disponível |

**Total: 1 TB RAM | 128 cores físicos**

---

### IBM DS3524 — Storage Dedicado (Futuro)
> 3 unidades de storage enterprise

- 24 bays SAS por unidade
- Discos SAS 600 GB
- ~43 TB bruto total
- Firmware SANtricity proprietário

---

### Rede
- **Switch:** MikroTik gerenciável
- **Faixa de IPs:** Definida internamente (não publicada)

---

## 🗺️ Mapa de IPs

Por segurança, o endereçamento interno detalhado não é publicado neste repositório.
Use o padrão abaixo apenas como referência de organização:

| Dispositivo | Faixa lógica |
|-------------|---------------|
| SRV-1 a SRV-4 (Dell) | NÓS-COMPUTE |
| HP Blades (futuro) | EXPANSAO-COMPUTE |
| IBM DS3524 (futuro) | STORAGE |
| Reserva | LIVRE |

---

## ⚙️ Stack de Software

| Camada | Tecnologia |
|--------|-----------|
| Hypervisor | Proxmox VE 8.x |
| Cluster | Proxmox Cluster (4 nós) |
| Storage local | LVM-Thin por nó |
| Storage compartilhado | TrueNAS (planejado) |
| OS base | Debian Bookworm |
| Repositório | Proxmox No-Subscription |

---

## 🎯 Casos de Uso

- **LLMs / IA** — Modelos quantizados (Llama, Qwen) via Ollama
- **Pesquisa universitária** — VMs isoladas por projeto
- **Servidores de jogo** — Minecraft, Valheim, Hytale
- **Laboratório de redes** — Ambiente de aprendizado prático
- **Futuramente** — Cloud privada com OpenStack nos blades HP

---

## 📋 Roadmap

- [x] Instalação Proxmox VE nos 4 nós Dell
- [x] Configuração do cluster Proxmox
- [x] Configuração de usuários e grupos (ADM, Alunos, AlunosSudo)
- [x] Repositórios no-subscription em todos os nós
- [x] Sincronização de horário (NTP / America/Sao_Paulo)
- [ ] Configurar storage local (LVM-Thin) em cada nó
- [ ] Subir primeiras VMs (Minecraft, LLM)
- [ ] Servidor TrueNAS dedicado (IBM DS3524 + discos)
- [ ] Integrar blades HP ao cluster
- [ ] Avaliar OpenStack bare metal nos blades HP
- [ ] Ceph quando switch for atualizado

---

## 👥 Equipe

| Usuário | Papel |
|---------|-------|
| usuário-admin | ADM |
| usuário-aluno | Aluno |

---

## 📁 Estrutura do Repositório

```
.
├── README.md
├── docs/
│   ├── hardware.md        # Specs detalhadas de cada equipamento
│   ├── rede.md            # Diagrama e configuração de rede
│   └── proxmox.md         # Guia de configuração do Proxmox
├── scripts/
│   ├── setup_node.sh      # Configuração inicial de cada nó
│   └── fix_repos.sh       # Corrige repositórios no-subscription
└── vms/
    └── templates/         # Templates de VMs
```

---

## 🚀 Setup Inicial de um Novo Nó

```bash
# Execute em ambiente de homologação antes de aplicar em produção.
# Ajuste os caminhos/nomes conforme a realidade do seu nó.

# 1. Corrigir repositórios (valide antes de sobrescrever arquivos)
cp /etc/apt/sources.list.d/pve-enterprise.list \
  /etc/apt/sources.list.d/pve-enterprise.list.bak 2>/dev/null || true
printf '%s\n' 'deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription' \
  | tee /etc/apt/sources.list.d/pve-no-subscription.list > /dev/null

# 2. Atualizar sistema
apt update && apt dist-upgrade -y

# 3. Configurar timezone e NTP
timedatectl set-timezone America/Sao_Paulo
timedatectl set-ntp true
systemctl enable --now systemd-timesyncd

# 4. Adicionar entradas DNS locais em /etc/hosts
cat <<'EOF' >> /etc/hosts
# Exemplo: substitua pelos IPs e FQDNs do seu ambiente
10.0.0.20 srv1.exemplo.local srv1
10.0.0.21 srv2.exemplo.local srv2
10.0.0.22 srv3.exemplo.local srv3
10.0.0.23 srv4.exemplo.local srv4
EOF
```

---

> **Grupo Inovatech** — Universidade  
> Hardware enterprise. Propósito acadêmico. Ambiente profissional.