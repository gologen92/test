@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo ОШИБКА: Не найден Git-репозиторий!
    echo Запустите этот файл в папке вашего проекта.
    pause
    exit /b
)

echo Объединение ВСЕХ локальных коммитов в один...

for /f "delims=" %%i in ('git log --oneline origin/main..HEAD 2^>nul ^| find /c /v ""') do set commit_count=%%i

if "!commit_count!"=="" (
    for /f "delims=" %%i in ('git rev-list --count HEAD 2^>nul') do set commit_count=%%i
)

if "!commit_count!"=="" set commit_count=0
if !commit_count! LEQ 1 (
    echo Нет коммитов для объединения.
    pause
    exit /b
)

echo Количество коммитов для объединения: !commit_count!

set /p answer="Вы уверены, что хотите объединить !commit_count! коммитов? (y/n): "
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

for /f "delims=" %%i in ('git branch --show-current') do set branch_name=%%i

git reset --soft HEAD~!commit_count!
git add .
git commit -m "!commit_message!"

echo Отправляем изменения на GitHub...
git push --force-with-lease origin !branch_name!

if errorlevel 1 (
    echo Ошибка при отправке. Пробуем обычный force...
    git push --force origin !branch_name!
)

echo Готово! Все !commit_count! коммитов объединены в один и отправлены в GitHub.
pause