@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo Объединение последних 3 коммитов в один...

set /p answer="Вы уверены, что хотите объединить последние 3 коммита? (y/n): "
if /i not "!answer!"=="y" (
    echo Отменено.
    pause
    exit /b
)

set /p commit_message="Введите описание коммита: "
if "!commit_message!"=="" (
    echo Сообщение коммита не может быть пустым!
    pause
    exit /b
)

git reset --soft HEAD~3
git add .
git commit -m "!commit_message!"
git push origin main

echo Готово! Коммиты объединены и отправлены в GitHub.
pause