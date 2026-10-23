# Contratos Avro

Os arquivos `.avsc` são contratos de referência do domínio. O formato final dos tópicos CDC depende do conector escolhido; envelopes Debezium não são iguais a registros simples de transação. Ajuste os schemas para corresponder ao payload efetivamente emitido antes de registrar e consumir os tópicos.

Teste evolução BACKWARD:
- adicionar campo opcional com `default`;
- tentar remover um campo obrigatório e verificar a rejeição;
- guardar os resultados reais em `evidencias/02-schemas.md`.

Valores monetários estão representados com `bytes` e logical type `decimal`, precisão 15 e escala 2.
