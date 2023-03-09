# Цель проекта
Развернуть сайт на внешнем сервере инструментами devops и автоматизировать развертывание.

# DevOps инструменты:
- Yandex Cloud
- Github 
- Terraform
- Ansible
- Jenkins

# DevOps проект https://github.com/nargo0o/devops_project:
- Django application
- Postgres DB

## Шаги установки вебсервера
- Веб сервер - nginx
- СУБД - PostgreSQL

### Ansible таски:
- Apt update
- Git
- Python packages
- Django
- Postgres, изменить конфиги, создание БД 
- Копирование исходного кода из гитхаб репозитория
- Активация виртуального окружения и установка зависимостей 
- Миграции и заполнение БД продуктами
- Gunicorn + настройка gunicorn
- Nginx, настройка параметров nginx
- Создание конфигов в sites-available и подключение в sites-enabled
- Перезапуск nginx
- Перезапуск gunicorn

![image](https://user-images.githubusercontent.com/58916643/224145643-a119140d-8d64-49ca-a690-4cc2dc81aae2.png)
