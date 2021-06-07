# Домашнее задание к занятию "7.1. Инфраструктура как код"

## Задача 1

1. Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый? __не изменяемый__
2. Будет ли центральный сервер для управления инфраструктурой? __нет__
3. Будут ли агенты на серверах? __нет__
4. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов? __инициализация ресурсов__

Какие инструменты из уже используемых вы хотели бы использовать для нового проекта? __Packer, Terraform, Docker, k8s, Teamcity__

Хотите ли рассмотреть возможность внедрения новых инструментов для этого проекта? __да__

## Задача 2

```
terraform -v
Terraform v0.15.5
on linux_amd64
```

## Задача 3

```
./terraform12 -v
Terraform v0.12.0

Your version of Terraform is out of date! The latest version
is 0.15.5. You can update by downloading from www.terraform.io/downloads.html


./terraform13 -v

Your version of Terraform is out of date! The latest version
is 0.15.5. You can update by downloading from https://www.terraform.io/downloads.html
Terraform v0.13.0
```