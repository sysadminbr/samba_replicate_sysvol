# samba_replicate_sysvol
Shell Script to Replicate SYSVOL from PdcEmulator to Additional Samba Domain Controller  

## Instalação  
1. Crie a pasta /scripts e salve o script sync_sysvol.sh lá dentro.  
```
mkdir /scripts 
```
2. Dê permissão de execução no script com o comando:  
```
chmod +x /scripts/sync_sysvol.sh
```
3. Agende o script para execução no crontab (crontab -e) para executar a cada 15 minutos:  
```
#m h dom mon dow command
*/15 * * * * /scripts/sync_sysvol.sh >/dev/null
```

4. Execute o script manualmente para ter certeza que não há nenhum erro na replicação. O script irá localizar o nome do domínio e o servidor samba com a função FSMO PdcEmulator através do comando samba-tool.  
```
/scripts/sync_sysvol.sh
```
Feito!
