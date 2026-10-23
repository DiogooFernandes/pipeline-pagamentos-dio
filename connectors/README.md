# CDC PostgreSQL — modelo

`postgres-cdc.example.json` é uma referência de configuração Debezium, não uma configuração universal pronta para importar. A sintaxe de segredos e as propriedades aceitas dependem do serviço/conector utilizado.

Antes de usar:
- confirme se a conta oferece o conector escolhido;
- confirme conectividade de rede até o banco;
- configure credenciais em mecanismo de secrets suportado, nunca no JSON versionado;
- valide privilégios, publication, replication slot, retenção de WAL e TLS;
- confirme o formato de saída, os nomes de tópicos e o schema;
- valide os três tipos de evento com mensagens reais.

O PostgreSQL do `docker-compose.yml` escuta apenas em `127.0.0.1` do seu PC. Um conector gerenciado na nuvem não pode alcançar esse endereço.
