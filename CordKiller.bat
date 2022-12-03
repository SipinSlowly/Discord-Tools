@echo off
setlocal enableextensions enabledelayedexpansion
:0
echo Batch Discord Tools [Creator: SipinSlowly]
echo 1 - Check One token
echo 2 - Check multiple tokens in txt file (.txt)
echo 3 - Delete webhook 
echo 4 - Spam webhook
echo 5 - GitHub
echo 0 - Exit  
set /p f=
if "%f%" == "5" cls & goto 5
if "%f%" == "4" cls & goto 4
if "%f%" == "3" cls & goto 3
if "%f%" == "0" exit
if "%f%" == "2" cls & goto 2
if "%f%" == "1" (cls & goto 1 
) else (cls & goto 0)

rem Single Token Checker
:1
set /p token="Your token: "
cls
for /F %%I in ('curl --silent -H "Content-Type: application/json" -H "Authorization: %token%" https://discord.com/api/v9/users/@me/library') do set ValidToken=%%I
	if NOT %ValidToken%=={"message": (
		color 2 & echo Token is either valid or locked :/
		curl --silent -H "Content-Type: application/json" -H "Authorization: %token%" https://discordapp.com/api/v9/users/@me >> tokeninfo.json
		echo. >> tokeninfo.json
		echo.
		echo Saved token info in tokeninfo.json
	) else (
		color 4 & echo Token is invalid!
	)

set /P c="Do you want to check another token [Y/N]? "
if /I "%c%" EQU "Y" color 7 & cls & goto 1
if /I "%c%" EQU "N" (
color 7 & cls & goto 0
)
else (
color 7 && cls & goto 0
)

rem Mass Check Tokens | Broken . _.
:2
set /p pathTokens="Path to tokens (*.txt): "
if not exist %pathTokens% cls && echo File not found && timeout 5 && cls & goto 0
for /F "usebackq tokens=*" %%A in ("%pathTokens%") do (
	for /F %%I in ('curl --silent -H "Content-Type: application/json" -H "Authorization: %%A" https://discord.com/api/v9/users/@me/library') do set ValidTokens=%%I
		if NOT "%ValidTokens%"=="{""message"":" (
		echo "[Valid | Locked] %%A"
		curl --silent -H "Content-Type: application/json" -H "Authorization: %%A" https://discordapp.com/api/v9/users/@me >> tokeninfo.json
		echo. >> tokeninfo.json
		) else (
			echo "[Invalid] %%A"
		)
	)
echo Valid token are saved in "tokeninfo.json" (if any).

set /P idk="Do you want to return to main screen [Y/N]? "
if /I "%idk%" EQU "Y" cls & goto 0
if /I "%idk%" EQU "N" cls & goto 2
else cls & goto 0

rem Mass Delete Webhook
:3
echo [SPACE] between each webhook to delete multiple webhooks.
set /p input="Enter webhook: "
CURL -X "DELETE" %input%

set /P idk="Do you want to return to main screen [Y/N]? "
if /I "%idk%" EQU "Y" cls & goto 0
if /I "%idk%" EQU "N" cls & goto 3
else color 7 & cls & goto 0

rem Webhook Spammer
:4
set /p webhook="Enter Webhook: "
cls
set /p username="Enter Username: "
cls
set /p message="Enter Message: "
cls
set /p amount="Enter amount of times to spam: [x = Unlimited] "
rem No Limit Spammer
if "%amount%"=="x" (
:UnlimitedSpam
curl -d "content=%message%" -d "username=%username%" -X POST %webhook%
goto UnlimitedSpam
)
for /l %%a in (1, 1, %amount%) do (
curl -d "content=%message%" -d "username=%username%" -X POST %webhook%
cls
echo Message sent %%a times
)
echo.

set /P idk=Do you want to return to main screen [Y/N]? 
if /I "%idk%" EQU "Y" cls & goto 0
if /I "%idk%" EQU "N" cls & goto 4
else cls & goto 0

rem Open GitHub
:5
echo Opening GitHub...
start "" "https://github.com/sipinslowly"