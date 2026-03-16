/* PROJETO: Monitoramento de Falhas em Transações Críticas
OBJETIVO: Identificar erros de sistema e gargalos de performance (Timeouts)
AUTORA: Carolina Fernanda
*/

-- 1. IDENTIFICAR OS ERROS MAIS FREQUENTES NAS ÚLTIMAS 24 HORAS
-- Este relatório ajuda a priorizar qual problema o time de infra deve resolver primeiro.
SELECT 
    status_erro,
    codigo_resposta,
    COUNT(*) AS total_ocorrencias,
    MAX(data_transacao) AS ultima_falha
FROM 
    transacoes_pix
WHERE 
    status_transacao = 'FALHA'
    AND data_transacao >= datetime('now', '-1 day') -- Filtra as falhas de ontem para hoje
GROUP BY 
    status_erro, 
    codigo_resposta
ORDER BY 
    total_ocorrencias DESC;


-- 2. DETECTAR TIMEOUTS (LENTIDÃO NO SISTEMA)
-- Busca transações que demoraram mais de 5 segundos para responder. 
-- Essencial para reportar lentidão em "Salas de Guerra".
SELECT 
    id_transacao,
    id_cliente,
    tempo_resposta_ms,
    metodo_pagamento
FROM 
    transacoes_pix
WHERE 
    tempo_resposta_ms > 5000 
    AND status_transacao = 'PENDENTE'
ORDER BY 
    tempo_resposta_ms DESC;
