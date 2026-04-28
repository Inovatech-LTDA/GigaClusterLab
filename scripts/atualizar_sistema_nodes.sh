#!/bin/bash

# Atualiza o Ubuntu em todos os nós do cluster
# Este script assume que você tem acesso SSH a cada nó e que todos estão na mesma sub-rede.

# --- CONFIGURAÇÕES ---
USUARIO="your_username"
BASE_IP="192.168.1."
NODES="101 102 103 104 105"
CAMINHO_CHAVE="/path/to/your/private/key"
# --- --- --- --- ---

for SUFIXO in $NODES; do
  NODE="$BASE_IP$SUFIXO"
  echo "Atualizando $NODE..."
  ssh -i $CAMINHO_CHAVE $USUARIO@$NODE "sudo apt-get update && sudo apt-get upgrade -y"
done