# Домашнее задание к занятию "08.01 Введение в Ansible"

## Основная часть

1. Попробуйте запустить playbook на окружении из test.yml, зафиксируйте какое значение имеет факт some_fact для указанного хоста при выполнении playbook'a.
```
ansible-playbook -i playbook/inventory/test.yml playbook/site.yml 
TASK [Print fact]
ok: [localhost] => {
    "msg": 12
}
```
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
```
playbook/group_vars/all/examp.yml
```
3. Воспользуйтесь подготовленным (используется docker) или создайте собственное окружение для проведения дальнейших испытаний.
4. Проведите запуск playbook на окружении из prod.yml. Зафиксируйте полученные значения some_fact для каждого из managed host.
```
ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml

ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}
```
5. Добавьте факты в group_vars каждой из групп хостов так, чтобы для some_fact получились следующие значения: для deb - 'deb default fact', для el - 'el default fact'.
6. Повторите запуск playbook на окружении prod.yml. Убедитесь, что выдаются корректные значения для всех хостов.
```
ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml

ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
```
7. При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology.
```
ansible-vault encrypt_string "deb default fact" --name "some_fact
ansible-vault encrypt_string "el default fact" --name "some_fact
```
8. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь в работоспособности.
```
ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml --ask-vault-pass
```
9. Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node.
```
ansible-doc -t connection -l
ssh
```
10. В prod.yml добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь что факты some_fact для каждого из хостов определены из верных group_vars.
```
ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml --ask-vault-pass
TASK [Print fact] 
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
```
12. Заполните README.md ответами на вопросы. Сделайте git push в ветку master. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым playbook и заполненным README.md.

12.1 Где расположен файл с `some_fact` из второго пункта задания?
```
playbook/group_vars/all/examp.yml
```

12.2 Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?

```
ansible-playbook -i playbook/inventory/test.yml playbook/site.yml
```
12.3 Какой командой можно зашифровать файл?
```
ansible-vault encrypt <file>
```
12.4 Какой командой можно расшифровать файл?
```
ansible-vault decrypt <file>
```
12.5 Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?
```
ansible-vault view <file>
```
12.6 Как выглядит команда запуска `playbook`, если переменные зашифрованы?
```
ansible-playbook -i playbook/inventory/test.yml playbook/site.yml --ask-vault-pass
```
12.7 Как называется модуль подключения к host на windows?
```
winrm
```
12.8 Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh
```
ansible-doc -t connection ssh
```
12.9 Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?
```
remote_user
```