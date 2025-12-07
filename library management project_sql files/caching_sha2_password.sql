ALTER USER 'root'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY '********';
FLUSH PRIVILEGES;
SELECT user, host, plugin FROM mysql.user WHERE user = 'root';

-- 127.0.0.1 is your localhost IP Address
-- ********* is your own password