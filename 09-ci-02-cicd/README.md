# Практическое задание по теме «Процессы CI/CD»

## Знакомоство с SonarQube

### Подготовка к выполнению

1. Выполняем `docker pull sonarqube:8.7-community`
2. Выполняем `docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:8.7-community`
3. Ждём запуск, смотрим логи через `docker logs -f sonarqube`
4. Проверяем готовность сервиса через [браузер](http://localhost:9000)
5. Заходим под admin\admin, меняем пароль на свой

#### Ход работы

Проделаем шаги из списка выше и получим результат:

cp ~/Downloads/sonar-scanner-4.7.0.2747-macosx/bin/sonar-scanner /usr/local/bin/

![SonarQube Main](img/SonarQube-main.png)

### Основная часть

1. Создаём новый проект, название произвольное
2. Скачиваем пакет sonar-scanner, который нам предлагает скачать сам sonarqube
3. Делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
4. Проверяем `sonar-scanner --version`
5. Запускаем анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`
6. Смотрим результат в интерфейсе
7. Исправляем ошибки, которые он выявил(включая warnings)
8. Запускаем анализатор повторно - проверяем, что QG пройдены успешно
9. Делаем скриншот успешного прохождения анализа, прикладываем к решению ДЗ

#### Ход работы

1. Создаём проект под названием `netology`.
2. Скачиваем [SonarScanner](https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-macosx.zip).
3. Добавим бинарный файл в переменную `PATH`:

```shell
export PATH=/Users/romanmalyushkin/Downloads/sonar-scanner-4.7.0.2747-macosx/bin/:$PATH
```

4. Проверяем `sonar-scanner --version`:

```shell
sonar-scanner --version
INFO: Scanner configuration file: /Users/romanmalyushkin/Downloads/sonar-scanner-4.7.0.2747-macosx/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Mac OS X 10.15.7 x86_64
```

5. Запускаем анализатор для файла [fail.py](example/fail.py):

```shell
sonar-scanner \
  -Dsonar.projectKey=netology \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=5ff098a32e0e9dd00f5b79afba5af2091f2c4f20  \
  -Dsonar.coverage.exclusions=fail.py
```

6. Смотрим результат в интерфейсе:

![SonarQube failed](img/SonarQube-failed.png)

7. Исправляем ошибки, запускаем анализатор и проверяем результат в интерфейсе:

![SonarQube fixed](img/SonarQube-fixed.png)

...


