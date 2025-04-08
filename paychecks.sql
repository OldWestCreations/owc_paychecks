CREATE TABLE IF NOT EXISTS paycheck_storage (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(50) NOT NULL,
    job VARCHAR(50) NOT NULL,
    amount FLOAT NOT NULL DEFAULT 0,
    UNIQUE KEY unique_paycheck (identifier, job)
);
