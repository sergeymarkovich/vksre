# Создайте и включите файл подкачки при помощи swapon, size 4GB

1. `sudo dd if=/dev/zero of=/swapfile bs=1G count=4` создаем файл подкачки /swapfile размером 4 ГБ. Флаг if=/dev/zero указывает что нужно использовать нулевые байты для создания файла
2. `sudo chmod 600 /swapfile` запрещаем доступ к для других пользователей
3. `sudo mkswap /swapfile` создание идентификатора области подкачки в файле `/swapfile`
4. `sudo swapon /swapfile` включение файла подкачки
5. `sudo swapon --show` убедиться что все работает 