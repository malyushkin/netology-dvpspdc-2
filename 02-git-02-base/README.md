## Задание №2 – Теги

1. Создайте легковестный тег v0.0 на HEAD коммите и запуште его во все три добавленных на предыдущем этапе upstream.

```bash
git tag v0.0 e8b356b
git push origin --tags
git push gitlab --tags
git push bitbucket --tags
```

2. Аналогично создайте аннотированный тег v0.1.

```bash
git tag -a v0.1 e8b356b -m "v0.1"
```

## Задание №3 – Ветки

1.  Переключитесь обратно на ветку `main`, которая должна быть связана с веткой `main` репозитория на `github`.

```bash
git checkout origin/main
```

2. Посмотрите лог коммитов и найдите хеш коммита с названием `Prepare to delete and move`, который был создан в пределах предыдущего домашнего задания.

```bash
git log --oneline

399f2f8 Prepare to delete and move
```

3. Выполните `git checkout` по хешу найденного коммита.

```bash
git checkout 399f2f8
```

4. Создайте новую ветку `fix` базируясь на этом коммите `git switch -c fix`.

```bash
git switch -c fix
```

5. Отправьте новую ветку в репозиторий на гитхабе `git push -u origin fix`.

```bash
git push -u origin fix
```