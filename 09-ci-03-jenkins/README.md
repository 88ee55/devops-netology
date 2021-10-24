# Домашнее задание к занятию "09.03 Jenkins"

## Подготовка к выполнению

1. Установить jenkins по любой из [инструкций](https://www.jenkins.io/download/)
2. Запустить и проверить работоспособность
3. Сделать первоначальную настройку
4. Настроить под свои нужды
5. Поднять отдельный cloud
6. Для динамических агентов можно использовать [образ](https://hub.docker.com/repository/docker/aragast/agent)
7. Обязательный параметр: поставить label для динамических агентов: `ansible_docker`
8.  Сделать форк репозитория с [playbook](https://github.com/aragastmatb/example-playbook)

## Основная часть

1. Сделать Freestyle Job, который будет запускать `ansible-playbook` из форка репозитория

```
ansible-vault decrypt secret --vault-password-file vault_pass
mkdir ~/.ssh/
mv ./secret ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa
ansible-galaxy install -r requirements.yml -p roles
ansible-playbook site.yml -i inventory/prod.yml
```

2. Сделать Declarative Pipeline, который будет выкачивать репозиторий с плейбукой и запускать её

```
Создать item
Pipeline
Pipeline script
```

3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`
4. Перенастроить Job на использование `Jenkinsfile` из репозитория

Из пункта 2 меняем Pipeline script на Pipeline script from SCM. Указываем репозиторий `git@github.com:88ee55/devops-netology.git` и Script path `09-ci-03-jenkins/Jenkinsfile`

5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline)
6. Заменить credentialsId на свой собственный
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозитрий в файл `ScriptedJenkinsfile`
8. Отправить ссылку на репозиторий в ответе
