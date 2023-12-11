#!/bin/bash
wget https://raw.githubusercontent.com/iamspa/Other/main/GCP_Sync_Time.sh && chmod +x GCP_Sync_Time.sh && chmod -R 777 GCP_Sync_Time.sh && \
cd /usr/share/zoneinfo/Asia && rm -rf Jakarta && rm -rf /etc/localtime && wget https://raw.githubusercontent.com/iamspa/Other/main/Jakarta && \
ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime && cd && bash /root/GCP_Sync_Time.sh && rm -rf GCP_Sync_Time.sh*
