# daskain_microservices
daskain microservices repository

# Выполнено ДЗ №15

 - [x] Основное ДЗ
 - [ ] Задание со *

## В процессе сделано:
 - Разбирался как сети работают в Докере
 - Разобрался с docker-compose
 - Разобраться с параметризацией docker-compose

### Запуск nginx
Мы используем одну сеть с одним набором портов. Т.к. мы запускаем экземпляры NGINX на одном и том же порту, то рабочим будет только последний контейнер


### Параметры docker-compose
Судя по доке, имя проекта береться от имени папки, в которой лежит файл docker-compose. Его можно переопределить задав через флаг -p при запуске docker-compose:
```
docker-compose -p project_name up -d
```

Второй способ - использовать файл с параметрами .env. В него можно добавить все параметры, которые мы сможем параметризировать при создании файла.

## PR checklist
 - [ ] Выставил label с номером домашнего задания
 - [x] Выставил label с темой домашнего задания


# Выполнено ДЗ №16

 - [x] Основное ДЗ
 - [x] Задание со * Автоматизация развёртывания GitLab (по желанию)
 - [x] Задание со * Регистрация ранера через Ansible
 - [х] Задание со * Запуск reddit в контейнере
 - [ ] Задание со * Настройка оповещений в Slack

## В процессе сделано:
 - Развернул инстанс для Gitlab
 - При помощи Ansible  развернул на хосте gitlab
 - Запушил infra репозиторий в Gitlab

### Инстанс для gitlab
Создал инстанс через yc-cli:
```
yc compute instance create   --name gitlab-ci-vm   --memory=8   --zone ru-central1-a   --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4   --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=50   --ssh-key ./id_rsa.pub
```

### Gitlab и Ansible

Развернул инстанс при помощи Ansible playbook. На первом этапе подготовил хост (установил doker + окружение для него). На втором этапе, через шаблон, создал compose файл для запуска Gitlab.

Пароль для рута генериться при запуске контейнера, его можн найти в файле сонфигурации на хосте:
```
daskain@gitlab-ci-vm:/srv/gitlab/config$ sudo cat /srv/gitlab/config/initial_root_password
```

### Пайплайны
Создал пайплайн для инфра репозитория. Зарегистрировал раннер вручную. Создал Ansible плэйбук для регистрации ранеров.

Тесты не запустились, коллеги посоветовали добавить памяти в инстанс

### Запуск контейнера с reddit
Добавил в пайплайн, в build добавил использование ранее созданого docker образа



## PR checklist
 - [ ] Выставил label с номером домашнего задания
 - [x] Выставил label с темой домашнего задания


# Выполнено ДЗ №17

 - [x] Основное ДЗ
 - [ ] Задание со *

## В процессе сделано:
 - Переделал структуру репозитория
 - Равзернул мониторинг через прометей
 - Запушил образы в докер хаб

### Переделал структуру репозитория
Переделал структуру репозитория, перенес в папку docker папку docker-monolith. Создал папку monitoring

### Равзернул мониторинг через прометей
Используя докер, развернул инстасн прометея

### Запушил образы в докер хаб
Образы запушил в докер - https://hub.docker.com/u/daskain

## PR checklist
 - [ ] Выставил label с номером домашнего задания
 - [x] Выставил label с темой домашнего задания

# Выполнено ДЗ №18

 - [x] Основное ДЗ
 - [ ] Задание со *

## В процессе сделано:
 - Подготовка окружения
 - Логирование Docker-контейнеров
 - Сбор неструктурированных логов
 - Визуализация логов
 - Сбор структурированных логов
 - Распределенный трейсинг

### Окружение
Установил необходимые компоненты на ПК, пересобрал Docker-образы и запушил в свое репо
Создал и запустил хост с докером

### Структурированные логи
Настроил сбор логов для сервиса post. Index настроил на паттерн fluentd. Далее разбил логи на несколько полей через конфигу.

### Неструктурированные логи
Настроил сбор логов для сервиса ui. Далее разбил логи на несколько полей через конфигу.
Включил zipkin


## Как проверить
Создать хост:
```
 yc compute instance create \
  --name logging \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --memory=6 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
  --ssh-key ./id_rsa.pub
```

Запустить докер:
```
  docker-machine create \
  --driver generic \
  --generic-ip-address=<YANDEX_IP> \
  --generic-ssh-user yc-user \
  --generic-ssh-key ./id_rsa \
 logging
```

Сервис доступен по адресу:
```
http://YANDEX_IP:9292/
```

Кибана доступна по адресу:
```
http://YANDEX_IP:5601/
```


## PR checklist
 - [ ] Выставил label с номером домашнего задания
 - [x] Выставил label с темой домашнего задания

# Выполнено ДЗ №19

 - [x] Основное ДЗ
 - [x] Задание со *

## В процессе сделано:
 - Подготовил репо
 - Развернул кластер k8s в облаке
 - Развернул кластер через ansible и terraform


 ### Подготовка
 Создал папки в репо для ДЗ, добавил файлы манифестов


### Кластер кубера
Подготовил шаблон терраформа для мастер и воркер нод. В примере запустил 1 мастер, 2 воркер ноды. Через плэйбуки раскатал и подружил их между собой

Инвентори не динамическое, приходится руками править. Пока не знаю как сделать динамически.
Конфиги подгружается на локальную машину.

## Как проверить
Создать инстансы (3 штуки на данный момент):
```
terraform apply
```

Скопировать ip в inventory, запустить пайплайны.
Мастер:
```
ansible-playbook k8s_master.yml
```
Воркер:
```
ansible-playbook k8s_worker.yml
```

Скопировать конфигу на локуальную машину

Проверить ноды:
```
$kubectl get node
NAME    STATUS   ROLES           AGE     VERSION
k8s-0   Ready    control-plane   15m     v1.25.3
k8s-1   Ready    <none>          7m48s   v1.25.3
k8s-2   Ready    <none>          7m48s   v1.25.3
```
Создать поды:
```
$kubectl apply -f mongo-deployment.yml
$kubectl apply -f post-deployment.yml
$kubectl apply -f ui-deployment.yml
$kubectl apply -f comment-deployment.yml
```
Проверить поды:
```
$kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
comment-deployment-745b4cdb5f-4kvwq   1/1     Running   0          6m22s
mongo-deployment-759bbff9f9-x8llk     1/1     Running   0          6m13s
post-deployment-989d6d77c-pxc8k       1/1     Running   0          6m4s
ui-deployment-67ff9b5d5-lc6ns         1/1     Running   0          6m1s
```


## PR checklist
 - [ ] Выставил label с номером домашнего задания
 - [x] Выставил label с темой домашнего задания
