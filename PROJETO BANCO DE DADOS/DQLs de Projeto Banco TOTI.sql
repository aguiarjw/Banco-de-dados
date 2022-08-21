--PROJETO TOTI BANCO DE DADOS SQL Lite--

--1. Tem alguns Clientes que são dependentes. Quero que vocês me digam de que clientes eles são dependentes.--
--○ Por exemplo “Filho A” é dependente de qual outro cliente?

--Query #1--
SELECT id_conta AS ID_CONTA, c.id AS ID_CLIENTE, cteAnome AS CLIENTE , idcteB AS ID_DEP, nome AS DEPENDENTE
FROM cliente c 
JOIN (SELECT c.id AS idcteB, c.nome AS cteAnome, cc.id_conta AS clienteA
FROM cliente c
JOIN cliente_conta cc ON cc.id_cliente = c.id 
WHERE dependente=false)
JOIN cliente_conta cc ON cc.id_cliente = c.id AND clienteA = cc.id_conta
WHERE dependente=true
ORDER BY cteAnome;

--2. Quais foram as 5 contas que:--
--○ Mais fizeram transações - Query#2--
--○ Menos fizeram transações - Query#3--

--Query #2--
SELECT cc.id_conta, c.numero as "Número de Conta",
COUNT(t.id) AS "Número de trasacações"
FROM transacao t
JOIN cliente_conta cc
ON t.id_cliente_conta = cc.id
JOIN conta c
ON cc.id = c.id
GROUP BY c.id
ORDER BY COUNT(t.id) DESC
LIMIT 5;

--Query #3--
SELECT cc.id_conta, c.numero as "Número de Conta",
COUNT(t.id) AS "Número de trasacações"
FROM transacao t
JOIN cliente_conta cc
ON t.id_cliente_conta = cc.id
JOIN conta c
ON cc.id = c.id
GROUP BY c.id
ORDER BY COUNT(t.id) ASC
LIMIT 5;

--3. Tivemos uma perda de dados e não sabemos qual é o saldo de cada conta, mas temos todas as transações efetuadas--
--○ Queremos saber qual saldo total das contas registradas em banco!--
--■ Reparem que temos alguns tipos de transações que subtraem dinheiro e outros que somam.--

--Query #4--
SELECT c.numero AS 'NUMERO DE CONTA', (ingresos.total - egresos.total) AS SALDO
FROM conta c
JOIN (SELECT c.numero AS conta1, sum(valor) AS total
FROM transacao t
JOIN cliente_conta cc
ON cc.id = t.id_cliente_conta
JOIN conta c
ON c.id = cc.id_conta
WHERE id_tipo_transacao = 1
GROUP BY conta1) AS ingresos 
ON ingresos.conta1 = c.numero
JOIN (SELECT c.numero as conta2, sum(valor) AS total
FROM transacao t
JOIN cliente_conta cc
ON cc.id = t.id_cliente_conta
JOIN conta c ON c.id = cc.id_conta
WHERE id_tipo_transacao != 1
GROUP BY conta2) AS egresos
ON egresos.conta2 = c.numero
ORDER BY c.id;

