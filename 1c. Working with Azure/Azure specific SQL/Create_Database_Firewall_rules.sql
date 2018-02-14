

-- Query the database for existing rules
SELECT * FROM sys.database_firewall_rules;

-- Create one or more rules
EXEC sp_set_database_firewall_rule  N'Alle IPs' ,'0.0.0.0' ,'255.255.255.255';

-- delete a rule
EXEC sp_delete_database_firewall_rule N'Alle IPs';