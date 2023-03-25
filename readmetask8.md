# Запретите подключение к серверу при помощи пароля а также подключение от учетной записи root

1. nano /etc/ssh/sshd_config
2. PasswordAuthentication - его значение в `no`
3. PermitRootLogin - значение в `no`
4. перезапустить ssh-сервер `sudo systemctl restart sshd`
