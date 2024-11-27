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
    goto :error
)

REM Create Vite React project
echo Creating Vite React project...
call npm create vite@latest !PROJECT_NAME! -- --template react
if %errorlevel% neq 0 (
    echo Failed to create Vite React project.
    goto :error
)

REM Navigate into the project directory
cd !PROJECT_NAME!
if %errorlevel% neq 0 (
    echo Failed to navigate to the project directory.
    goto :error
)

REM Install project dependencies
echo Installing project dependencies...
call npm install
if %errorlevel% neq 0 (
    echo Failed to install project dependencies.
    goto :error
)

REM Install Tailwind CSS and its dependencies
echo Installing Tailwind CSS and its dependencies...
call npm install -D tailwindcss postcss autoprefixer
if %errorlevel% neq 0 (
    echo Failed to install Tailwind CSS and its dependencies.
    goto :error
)

REM Initialize Tailwind CSS
echo Initializing Tailwind CSS...
call npx tailwindcss init -p
if %errorlevel% neq 0 (
    echo Failed to initialize Tailwind CSS.
    goto :error
)

REM Add a small delay to ensure files are created and ready
timeout /t 2 /nobreak >nul

REM Modify tailwind.config.js (append content)
echo /** @type {import('tailwindcss').Config} */ > tailwind.config.js
echo export default { >> tailwind.config.js
echo   content: [ >> tailwind.config.js
echo     "./index.html", >> tailwind.config.js
echo     "./src/**/*.{js,ts,jsx,tsx}", >> tailwind.config.js
echo   ], >> tailwind.config.js
echo   theme: { >> tailwind.config.js
echo     extend: {}, >> tailwind.config.js
echo   }, >> tailwind.config.js
echo   plugins: [], >> tailwind.config.js
echo } >> tailwind.config.js
echo tailwind.config.js has been updated.

REM Modify index.css (append content)
echo @tailwind base; > src\index.css
echo @tailwind components; >> src\index.css
echo @tailwind utilities; >> src\index.css
echo index.css has been updated with Tailwind directives.

REM Add another delay before modifying App.jsx
timeout /t 2 /nobreak >nul

REM Modify App.jsx (only add Tailwind class to existing content)
echo Modifying App.jsx...

REM We will keep the default content of App.jsx but add the Tailwind class
powershell -Command "Add-Content -Path 'src\App.jsx' -Value 'import './App.css';`n`nfunction App() {`n  return (`n    <>`n      <p className=''text-amber-300 bg-black''>Hello World</p>`n    </>`n  );`n}`n`nexport default App;'"

echo App.jsx has been updated with the Tailwind class.

REM Confirm that files are updated and reflect the changes
echo.
echo The following files have been modified:
echo - tailwind.config.js
echo - src/index.css
echo - src/App.jsx

echo Vite React project with Tailwind CSS has been created and configured successfully!
echo Location: !PROJECT_LOCATION!\!PROJECT_NAME!

REM Instructions for starting the development server
echo.
echo To start your Vite development server, run the following commands:
echo cd !PROJECT_NAME!
echo npm run dev
echo.
echo Tailwind CSS is now set up and will process your CSS automatically.

goto :end

:error
echo An error occurred during the setup process.
echo Please check the error messages above and try again.

:end
REM Keep the window open
pause
