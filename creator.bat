@echo off
setlocal enabledelayedexpansion

REM Prompt for project name
set /p PROJECT_NAME=Enter the name of your Vite React project: 

REM Prompt for project location
set /p PROJECT_LOCATION=Enter the location for your project (or press Enter for current directory): 

REM If no location is provided, use the current directory
if "!PROJECT_LOCATION!"=="" set PROJECT_LOCATION=.

REM Navigate to the project location
cd /d "!PROJECT_LOCATION!"
if %errorlevel% neq 0 (
    echo Failed to navigate to the specified location.
    pause
    goto :error
)

REM Create Vite React project
echo Creating Vite React project...
call npm create vite@latest !PROJECT_NAME! -- --template react
if %errorlevel% neq 0 (
    echo Failed to create Vite React project.
    pause
    goto :error
)

REM Navigate into the project directory
cd !PROJECT_NAME!
if %errorlevel% neq 0 (
    echo Failed to navigate to the project directory.
    pause
    goto :error
)

REM Install project dependencies
echo Installing project dependencies...
call npm install
if %errorlevel% neq 0 (
    echo Failed to install project dependencies.
    pause
    goto :error
)

REM Install Tailwind CSS and @tailwindcss/vite
echo Installing Tailwind CSS and @tailwindcss/vite...
call npm install tailwindcss @tailwindcss/vite
if %errorlevel% neq 0 (
    echo Failed to install Tailwind CSS and @tailwindcss/vite.
    pause
    goto :error
)

REM Modify vite.config.js (overwrite content)
echo Overwriting vite.config.js...
echo import { defineConfig } from 'vite' > vite.config.js
echo import react from '@vitejs/plugin-react' >> vite.config.js
echo import tailwindcss from '@tailwindcss/vite' >> vite.config.js
echo. >> vite.config.js
echo // https://vite.dev/config/ >> vite.config.js
echo export default defineConfig({ plugins: [react(), tailwindcss()] }); >> vite.config.js
echo vite.config.js has been updated.

REM Modify index.css (add Tailwind import)
echo Adding Tailwind import to index.css...
echo @import "tailwindcss"; > src\index.css
echo index.css has been updated with Tailwind import.

REM Clear App.css (make it empty)
echo. > src\App.css
echo app.css has been cleared and is now empty.

REM Clear App.jsx (make it empty)
echo. > src\App.jsx
echo App.jsx has been cleared and is now empty.

REM Confirm that files are updated and reflect the changes
echo.
echo The following files have been modified:
echo - vite.config.js (overwritten)
echo - src/index.css (updated with Tailwind import)
echo - src/App.css (cleared, now empty)
echo - src/App.jsx (cleared, now empty)

echo Vite React project with Tailwind CSS has been created and configured successfully!
echo Location: !PROJECT_LOCATION!\!PROJECT_NAME!

REM Instructions for starting the development server
echo.
echo To start your Vite development server, run the following commands:
echo cd !PROJECT_NAME!
echo npm run dev
echo.

pause

goto :end

:error
echo An error occurred during the setup process.
echo Please check the error messages above and try again.

:end
