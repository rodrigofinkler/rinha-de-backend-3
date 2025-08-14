CREATE DATABASE IF NOT EXISTS rinha;

USE rinha;

CREATE TABLE cliente (
    id INTEGER NOT NULL AUTO_INCREMENT,
    saldo INTEGER DEFAULT 0,
    limite INTEGER,
    PRIMARY KEY (id)
);

CREATE TABLE transacao (
    id INTEGER NOT NULL AUTO_INCREMENT,
    id_cliente INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1),
    descricao VARCHAR(10),
    realizada_em DATETIME,
    PRIMARY KEY (id),
    FOREIGN KEY (id_cliente) REFERENCES cliente (id)
);


INSERT INTO cliente (saldo, limite) VALUES (0, 100000);
INSERT INTO cliente (saldo, limite) VALUES (0,80000);
INSERT INTO cliente (saldo, limite) VALUES (0,1000000);
INSERT INTO cliente (saldo, limite) VALUES (0,10000000);
INSERT INTO cliente (saldo, limite) VALUES (0,500000);


INSERT INTO transacao (id_cliente, valor, tipo, descricao, realizada_em) VALUES ( 1, 100, 'd', 'TR1', NOW());
INSERT INTO transacao (id_cliente, valor, tipo, descricao, realizada_em) VALUES ( 1, 200, 'd', 'TR2', NOW());
INSERT INTO transacao (id_cliente, valor, tipo, descricao, realizada_em) VALUES ( 1, 300, 'd', 'TR3', NOW());
INSERT INTO transacao (id_cliente, valor, tipo, descricao, realizada_em) VALUES ( 1, 400, 'd', 'TR4', NOW());
INSERT INTO transacao (id_cliente, valor, tipo, descricao, realizada_em) VALUES ( 1, 500, 'd', 'TR5', NOW());
INSERT INTO transacao (id_cliente, valor, tipo, descricao, realizada_em) VALUES ( 1, 600, 'd', 'TR6', NOW());
INSERT INTO transacao (id_cliente, valor, tipo, descricao, realizada_em) VALUES ( 1, 700, 'd', 'TR7', NOW());
INSERT INTO transacao (id_cliente, valor, tipo, descricao, realizada_em) VALUES ( 1, 800, 'd', 'TR8', NOW());
INSERT INTO transacao (id_cliente, valor, tipo, descricao, realizada_em) VALUES ( 1, 900, 'd', 'TR9', NOW());
INSERT INTO transacao (id_cliente, valor, tipo, descricao, realizada_em) VALUES ( 1, 1000, 'd', 'TR10', NOW());
INSERT INTO transacao (id_cliente, valor, tipo, descricao, realizada_em) VALUES ( 1, 1100, 'd', 'TR11', NOW());


WITH last_transactions AS(
        SELECT 
            id,
            JSON_OBJECT(
                'valor', valor,
                'tipo', tipo,
                'descricao', descricao,
                'realizada_em', realizada_em
            ) AS transacao_json 
        FROM transacao 
        WHERE id_cliente = 1 
        GROUP BY id 
        ORDER BY realizada_em DESC
        LIMIT 10
    )
SELECT saldo, limite, JSON_ARRAYAGG(transacao_json) AS ultimas_transacoes FROM last_transactions JOIN cliente ON id_cliente = cliente.id;


WITH last_transactions AS(
        SELECT
            id_cliente,
            id,
            JSON_OBJECT(
                'valor', valor,
                'tipo', tipo,
                'descricao', descricao,
                'realizada_em', realizada_em
            ) AS transacao_json 
        FROM transacao 
        WHERE id_cliente = 1 
        GROUP BY id 
        ORDER BY realizada_em DESC
        LIMIT 10
)
SELECT 
	JSON_OBJECT(
    	'total', saldo,
    	'data_extrato', NOW(),
    	'limite', limite
    ) AS saldo,
    JSON_ARRAYAGG(transacao_json) AS ultimas_transacoes 
FROM last_transactions JOIN cliente ON id_cliente = cliente.id;