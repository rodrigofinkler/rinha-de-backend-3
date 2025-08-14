CREATE DATABASE IF NOT EXISTS rinha;

USE rinha;

CREATE TABLE
    payments (
        correlationId CHAR(36) NOT NULL PRIMARY KEY, -- UUID v4, generated in backend
        requestedAt DATETIME (3) NOT NULL DEFAULT (UTC_TIMESTAMP (3)),
        amount DECIMAL(15, 2) NOT NULL, -- allows billions with 2 decimal places
        fee DECIMAL(5, 2) NOT NULL, -- allows percentages up to 999.99%
        processor ENUM ('default', 'fallback') NOT NULL
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;