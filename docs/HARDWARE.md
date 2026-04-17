# Hardware do Laboratorio GigaCluster

Este documento detalha os equipamentos fisicos do laboratorio, com foco em capacidade, papel no ambiente e boas praticas de operacao.

## Visao Geral do Parque

| Categoria | Equipamento | Quantidade | Funcao principal |
|-----------|-------------|------------|------------------|
| Compute principal | Dell PowerEdge C6100 | 1 chassi / 4 nos | Cluster de virtualizacao |
| Compute de expansao | HP ProLiant BL460c Gen8 | 8 blades | Expansao de carga e projetos futuros |
| Enclosure blades | HP BladeSystem c7000 | 1 | Infraestrutura dos blades HP |
| Storage dedicado | IBM DS3524 | 3 unidades | Armazenamento compartilhado futuro |
| Rede | Switch MikroTik gerenciavel | 1 | Segmentacao e conectividade interna |

## 1) Dell PowerEdge C6100 (Cluster Principal)

### Perfil do equipamento

O Dell C6100 e um chassi 2U de alta densidade com 4 nos independentes. Cada no opera como servidor separado, permitindo formar um cluster resiliente com bom aproveitamento de espaco e energia.

### Configuracao consolidada

| Item | Por no | Total no chassi |
|------|--------|-----------------|
| CPU | 2x Intel Xeon X5650 | 8 CPUs fisicas |
| RAM | 64 GB DDR3 | 256 GB |
| Armazenamento local | 5 TB | 20 TB brutos |
| Nos | 1 | 4 |

### Pontos fortes

- Alta densidade de computacao em pouco espaco fisico.
- Boa base para laboratorio de virtualizacao com Proxmox.
- Permite distribuicao de carga entre nos para manutencao sem parada total.

### Limitacoes esperadas

- Plataforma de geracao anterior, com menor eficiencia energetica que hardware moderno.
- DDR3 e CPU mais antiga podem limitar workloads de IA nao quantizada.
- Armazenamento local exige estrategia de backup e replicacao entre nos.

### Uso recomendado no laboratorio

- Hospedar VMs de disciplinas, pesquisa e servicos internos.
- Executar containers e laboratorios isolados por turma/projeto.
- Servir como base do cluster inicial ate a integracao de storage compartilhado.

## 2) HP ProLiant BL460c Gen8 + c7000 (Expansao)

### Perfil do equipamento

Os blades BL460c Gen8 instalados no c7000 formam uma plataforma de expansao com foco em escala de computacao. Esse conjunto e ideal para crescimento modular do cluster.

### Configuracao consolidada

| Item | Por blade | Total (8 blades) |
|------|-----------|------------------|
| CPU | 2x Intel Xeon E5-2650 | 16 CPUs fisicas |
| RAM | 128 GB | 1 TB |
| Cores fisicos (referencia do projeto) | 16 | 128 |

### Papel estrategico

- Reservar para crescimento de cargas de ensino e pesquisa.
- Avaliar como base para cloud privada (ex.: OpenStack) em fase posterior.
- Direcionar workloads que precisem de mais memoria agregada.

### Cuidados operacionais

- Validar consumo eletrico e capacidade de refrigeração antes de ativacao plena.
- Confirmar firmware de blades e enclosure antes da entrada em producao.
- Planejar janela de testes para integracao com o cluster existente.

## 3) IBM DS3524 (Storage Dedicado Futuro)

### Perfil do equipamento

O DS3524 e um storage enterprise com foco em centralizacao de discos e servicos de armazenamento para varios hosts, reduzindo dependencia de disco local por no.

### Capacidade prevista

| Item | Valor |
|------|-------|
| Unidades | 3 |
| Bays por unidade | 24 |
| Tipo de disco | SAS 600 GB |
| Capacidade bruta total estimada | ~43 TB |
| Firmware | SANtricity |

### Beneficios esperados

- Base para storage compartilhado entre hosts de virtualizacao.
- Melhor governanca de volumes e crescimento de capacidade.
- Caminho para politicas de alta disponibilidade no armazenamento.

### Riscos e atencoes

- Exige planejamento de RAID, performance e tolerancia a falhas.
- Necessario validar compatibilidade com stack escolhida para o cluster.
- Requer rotinas de monitoramento e manutencao de discos/firmware.

## 4) Rede e Conectividade

O ambiente utiliza switch MikroTik gerenciavel, com segmentacao interna definida pelo time. O detalhamento de enderecamento nao e publicado por seguranca.

### Boas praticas de rede para o laboratorio

- Separar trafego de gerenciamento, armazenamento e workloads.
- Padronizar nomes logicos para nos, blades e storage.
- Manter inventario de portas, VLANs e uplinks em documento interno controlado.

## 5) Leitura de Capacidade por Cenario

### Cenario atual (Dell C6100 ativo)

- Memoria total: 256 GB
- Armazenamento local bruto: ~20 TB
- Perfil ideal: virtualizacao leve/media, laboratorios e servicos internos

### Cenario expandido (Dell + HP)

- Memoria agregada estimada: 1.25 TB
- Aumento significativo de densidade de computacao
- Perfil ideal: multiplos projetos simultaneos, maior consolidacao de VMs

### Cenario futuro com storage dedicado

- Ganho de flexibilidade para mover cargas entre hosts
- Melhor base para alta disponibilidade de dados
- Estrutura mais adequada para cloud privada e pesquisa de infraestrutura

## 6) Operacao e Manutencao

### Checklist minimo de saude do hardware

- Verificar alertas de temperatura e ventilacao.
- Revisar estado de discos e controladoras periodicamente.
- Conferir logs de hardware apos quedas de energia.
- Manter firmwares em ciclo de atualizacao planejado.

### Boas praticas administrativas

- Registrar toda mudanca de hardware em historico de manutencao.
- Executar testes de desempenho apos mudancas relevantes.
- Priorizar ambiente de homologacao antes de alteracoes de producao.

## 7) Referencias dos Manuais

Os manuais tecnicos oficiais estao disponiveis na pasta [Manuais/](../Manuais/):

- DELL PowerEdge c6100
- HP ProLiant BL460c Gen8
- HP BladeSystem c7000 Enclosure
- IBM System Storage DS3500

Use os manuais para validacao de pecas, procedimentos fisicos de manutencao, firmware e limites suportados por cada plataforma.
