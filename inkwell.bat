@echo off
setlocal enabledelayedexpansion

REM === Script directory (where inkwell.bat lives) ===
set "SCRIPT_DIR=%~dp0"

REM === Today's date ===
set "TODAY=%date%"

REM === Enable ANSI escape codes (Windows 10+) ===
for /f %%a in ('echo prompt $E ^| cmd') do set "E=%%a"

REM === Colour shortcuts ===
set "R=%E%[0m"
set "DIM=%E%[90m"
set "WHITE=%E%[97m"
set "CYAN=%E%[96m"
set "GREEN=%E%[92m"
set "YELLOW=%E%[93m"
set "RED=%E%[91m"
set "BOLD=%E%[1m"

REM ============================================================
REM  :DrawHeader — Reusable banner with step indicator
REM  Usage: set "STEP=1 of 4" & set "STEP_NAME=Choose Type" & call :DrawHeader
REM ============================================================
goto :Welcome

:DrawHeader
cls
echo.
echo  %DIM%  ___         __                 __ __%R%
echo  %DIM% ^|_ _^|_ __   / /__ __      _____/ // /%R%
echo  %CYAN%  ^| ^|^| '_ \ / / /\ \ /\ / / _ \ // / %R%
echo  %CYAN%  ^| ^|^| ^| ^| ^/ /\ \  V  V /  __/ // /  %R%
echo  %WHITE% ^|___^|_^| ^|_\/ \/  \_/\_/ \___)__/_/   %R%
echo.
echo  %DIM% ............................................%R%
echo  %WHITE%  Step !STEP!%R%  %DIM%—%R%  %CYAN%!STEP_NAME!%R%
echo  %DIM% ............................................%R%
echo.
goto :eof

REM ============================================================
REM  Screen 1: Welcome
REM ============================================================
:Welcome
cls
echo.
echo  %DIM%  ___         __                 __ __%R%
echo  %DIM% ^|_ _^|_ __   / /__ __      _____/ // /%R%
echo  %CYAN%  ^| ^|^| '_ \ / / /\ \ /\ / / _ \ // / %R%
echo  %CYAN%  ^| ^|^| ^| ^| ^/ /\ \  V  V /  __/ // /  %R%
echo  %WHITE% ^|___^|_^| ^|_\/ \/  \_/\_/ \___)__/_/   %R%
echo.
echo  %DIM% ............................................%R%
echo  %WHITE%  Etsy Digital Product Setup Tool%R%
echo  %DIM% ............................................%R%
echo.
echo  %DIM% Create a new product folder with everything%R%
echo  %DIM% you need to design, export, and list on Etsy.%R%
echo.
echo.
set "START="
set /p "START= %YELLOW% >> %R% Press Enter to get started... "
echo.

REM ============================================================
REM  Screen 2: Choose Type
REM ============================================================
:ChooseType
set "STEP=1 of 4" & set "STEP_NAME=Choose Product Type" & call :DrawHeader

echo  %WHITE% What type of product are you creating?%R%
echo.
echo  %CYAN%   [1]%R%  Planner
echo  %CYAN%   [2]%R%  Journal
echo  %CYAN%   [3]%R%  Printable
echo  %CYAN%   [4]%R%  Workbook
echo.
set "PRODUCT_TYPE="
set /p "PRODUCT_TYPE= %YELLOW% >> %R% Pick a number (1-4): "

if "!PRODUCT_TYPE!"=="1" (
    set "TYPE_NAME=Planner"
    set "PREFIX=PLN"
    set "CATEGORY=Planners"
    goto :AutoNumber
)
if "!PRODUCT_TYPE!"=="2" (
    set "TYPE_NAME=Journal"
    set "PREFIX=JRN"
    set "CATEGORY=Journals"
    goto :AutoNumber
)
if "!PRODUCT_TYPE!"=="3" (
    set "TYPE_NAME=Printable"
    set "PREFIX=PRT"
    set "CATEGORY=Printables"
    goto :AutoNumber
)
if "!PRODUCT_TYPE!"=="4" (
    set "TYPE_NAME=Workbook"
    set "PREFIX=WBK"
    set "CATEGORY=Workbooks"
    goto :AutoNumber
)

echo.
echo  %RED% x%R%  That's not one of the options — pick 1 to 4!
echo.
pause >nul
goto :ChooseType

REM ============================================================
REM  Auto-number (no screen — runs silently)
REM ============================================================
:AutoNumber
set "CATEGORY_PATH=%SCRIPT_DIR%%CATEGORY%"
if not exist "!CATEGORY_PATH!" mkdir "!CATEGORY_PATH!"

set "COUNT=0"
for /d %%D in ("!CATEGORY_PATH!\!PREFIX!-*") do set /a COUNT+=1
set /a NEXT=COUNT+1
if !NEXT! lss 10 (
    set "NUM=00!NEXT!"
) else if !NEXT! lss 100 (
    set "NUM=0!NEXT!"
) else (
    set "NUM=!NEXT!"
)
set "PRODUCT_ID=!PREFIX!-!NUM!"

REM ============================================================
REM  Screen 3: Name Your Product
REM ============================================================
:EnterName
set "STEP=2 of 4" & set "STEP_NAME=Name Your Product" & call :DrawHeader

echo  %GREEN% *%R%  Type: %WHITE%!TYPE_NAME!%R%
echo  %GREEN% *%R%  Next number: %BOLD%%WHITE%!PRODUCT_ID!%R%
echo.
echo  %DIM% Give your product a name, or press Enter to%R%
echo  %DIM% skip and just use the number ^(!PRODUCT_ID!^).%R%
echo.
set "PRODUCT_NAME="
set /p "PRODUCT_NAME= %YELLOW% >> %R% Product name: "

if "!PRODUCT_NAME!"=="" (
    set "FOLDER_NAME=!PRODUCT_ID!"
) else (
    set "FOLDER_NAME=!PRODUCT_ID! - !PRODUCT_NAME!"
)

set "PRODUCT_PATH=!CATEGORY_PATH!\!FOLDER_NAME!"

if exist "!PRODUCT_PATH!" (
    echo.
    echo  %RED% x%R%  A folder called %WHITE%"!FOLDER_NAME!"%R% already exists!
    echo    %DIM%Please choose a different name.%R%
    echo.
    pause >nul
    goto :EnterName
)

REM ============================================================
REM  Screen 4: Confirm
REM ============================================================
:Confirm
set "STEP=3 of 4" & set "STEP_NAME=Confirm" & call :DrawHeader

echo  %DIM% Here's what will be created:%R%
echo.
echo    %DIM%Type     %WHITE%!TYPE_NAME!%R%
echo    %DIM%ID       %CYAN%!PRODUCT_ID!%R%
if not "!PRODUCT_NAME!"=="" (
    echo    %DIM%Name     %WHITE%!PRODUCT_NAME!%R%
)
echo    %DIM%Folder   %WHITE%!CATEGORY!\!FOLDER_NAME!%R%
echo.
echo    %DIM%Files:%R%
echo    %DIM%  Source Files\  Exports\  Mockups\%R%
echo    %DIM%  Listing\  Assets\  README.txt%R%
echo    %DIM%  tasks.md  notes.md  listing.md%R%
echo.

set "CONFIRM="
set /p "CONFIRM= %YELLOW% >> %R% Look good? (%GREEN%Y%R%/%RED%N%R%): "

if /i "!CONFIRM!"=="Y" goto :CreateAll
if /i "!CONFIRM!"=="N" (
    echo.
    echo  %DIM% No worries! Run the script again when you're ready.%R%
    goto :End
)
echo.
echo  %RED% x%R%  Please type Y or N.
pause >nul
goto :Confirm

REM ============================================================
REM  Screen 5: Creating...
REM ============================================================
:CreateAll
set "STEP=4 of 4" & set "STEP_NAME=Creating Product" & call :DrawHeader

echo  %DIM% Setting up your product folder...%R%
echo.

REM === Folders ===
mkdir "!PRODUCT_PATH!\Source Files" 2>nul
if !ERRORLEVEL! neq 0 (
    echo  %RED% x  ERROR: Could not create folders.%R%
    echo  %DIM%   Check you have permission to write here.%R%
    goto :End
)
mkdir "!PRODUCT_PATH!\Exports" 2>nul
mkdir "!PRODUCT_PATH!\Mockups" 2>nul
mkdir "!PRODUCT_PATH!\Listing" 2>nul
mkdir "!PRODUCT_PATH!\Assets" 2>nul

echo  %GREEN% +%R%  Folders created

REM === README.txt ===
(
    echo ========================================
    echo   !FOLDER_NAME!
    echo   Type: !TYPE_NAME!
    echo   Created: !TODAY!
    echo ========================================
    echo.
    echo This folder was created by Inkwell.
    echo.
    echo FOLDER GUIDE:
    echo.
    echo   Source Files/   Your working .ai ^(Illustrator^) files go here.
    echo                   Save versions as you go ^(e.g. design-v1.ai, design-v2.ai^).
    echo.
    echo   Exports/        Final PDFs and print-ready files for buyers.
    echo                   Export from Illustrator when your design is finished.
    echo.
    echo   Mockups/        Product images for your Etsy listing.
    echo                   Show how the product looks in real life ^(flat lay, on desk, etc.^).
    echo.
    echo   Listing/        Your Etsy listing copy. Open listing.md and fill it in.
    echo.
    echo   Assets/         Fonts, colour palettes, graphics, and inspiration.
    echo                   Keep track of what you used so you can reuse it later.
    echo.
) > "!PRODUCT_PATH!\README.txt"

if "!PRODUCT_TYPE!"=="1" (
    (
        echo ========================================
        echo TIPS FOR PLANNERS:
        echo.
        echo   - A5 and Letter are the most popular sizes on Etsy
        echo   - Consider offering both dated and undated versions
        echo   - Include a binding margin if buyers might print and bind
        echo   - Weekly, monthly, and daily spreads sell well together
        echo   - Undated planners have a longer shelf life
        echo.
    ) >> "!PRODUCT_PATH!\README.txt"
)
if "!PRODUCT_TYPE!"=="2" (
    (
        echo ========================================
        echo TIPS FOR JOURNALS:
        echo.
        echo   - The cover design is what buyers see first — make it stand out
        echo   - Write your prompts in a separate document before designing
        echo   - Test that interior pages print cleanly in colour and greyscale
        echo   - Guided journals with a clear theme sell better than generic ones
        echo   - Consider including a "how to use this journal" intro page
        echo.
    ) >> "!PRODUCT_PATH!\README.txt"
)
if "!PRODUCT_TYPE!"=="3" (
    (
        echo ========================================
        echo TIPS FOR PRINTABLES:
        echo.
        echo   - Always design at 300 DPI for sharp printing
        echo   - Use CMYK colour mode for print files, RGB for digital-only
        echo   - Offer multiple sizes ^(A4 and Letter at minimum^)
        echo   - Wall art should include a bleed area for trimming
        echo   - Show mockups of the printable framed or in a real setting
        echo.
    ) >> "!PRODUCT_PATH!\README.txt"
)
if "!PRODUCT_TYPE!"=="4" (
    (
        echo ========================================
        echo TIPS FOR WORKBOOKS:
        echo.
        echo   - Clearly state the target age range in your listing
        echo   - Include an answer key — parents and teachers expect it
        echo   - Test your activities with someone in the target age group
        echo   - Progressive difficulty keeps children engaged
        echo   - Consider including a progress tracker or reward page
        echo.
    ) >> "!PRODUCT_PATH!\README.txt"
)

echo  %GREEN% +%R%  README.txt

REM === listing.md ===
(
    echo # Etsy Listing — !FOLDER_NAME!
    echo.
    echo **Type:** !TYPE_NAME!
    echo **Created:** !TODAY!
    echo.
    echo ---
    echo.
    echo ## Product Title
    echo.
    echo ^> Etsy allows 140 characters. Put your most important keywords first.
    echo ^> Include what it is + who it's for + a key feature.
    echo ^> Example: *"Daily Planner Printable ^| A5 Undated ^| Minimalist Design"*
    echo.
    echo **Title:**
    echo.
    echo ---
    echo.
    echo ## Description
    echo.
    echo Answer these questions to write your description:
    echo.
    echo **1. What is this product?**
    echo ^> e.g. *"A 12-month undated daily planner..."*
    echo.
    echo.
    echo.
    echo **2. Who is it for?**
    echo ^> e.g. *"Perfect for busy professionals who..."*
    echo.
    echo.
    echo.
    echo **3. What's included in the download?**
    echo ^> e.g. *"You'll receive 3 PDF files..."*
    echo.
    echo.
    echo.
    echo **4. How do they use it?**
    echo ^> e.g. *"Simply download, print at home or at a print shop..."*
    echo.
    echo.
    echo.
    echo ---
    echo.
    echo ## Tags
    echo.
    echo ^> Etsy allows up to 13 tags. **Use all 13!** Think about what a buyer would search for.
    echo.
    echo 1.
    echo 2.
    echo 3.
    echo 4.
    echo 5.
    echo 6.
    echo 7.
    echo 8.
    echo 9.
    echo 10.
    echo 11.
    echo 12.
    echo 13.
    echo.
    echo ---
    echo.
    echo ## Pricing
    echo.
    echo ^| Detail ^| Value ^|
    echo ^| --- ^| --- ^|
    echo ^| Your price ^| ^|
    echo ^| Competitor range ^| ^|
    echo ^| Notes ^| ^|
    echo.
    echo ---
    echo.
    echo ## File Formats Included
    echo.
    echo ^> List every file the buyer will receive ^(e.g. PDF - A4, PDF - Letter, PNG 300 DPI^)
    echo.
    echo - [ ]
    echo - [ ]
    echo - [ ]
    echo.
) > "!PRODUCT_PATH!\Listing\listing.md"

if "!PRODUCT_TYPE!"=="1" (
    (
        echo ---
        echo.
        echo ## Planner Details
        echo.
        echo ^| Detail ^| Value ^|
        echo ^| --- ^| --- ^|
        echo ^| Page count ^| ^|
        echo ^| Date range ^| dated / undated ^|
        echo ^| Paper sizes ^| A4 / A5 / Letter / Half Letter ^|
        echo ^| Orientation ^| portrait / landscape ^|
        echo ^| Binding margin ^| Yes / No ^|
        echo ^| Key features ^| monthly overview, weekly spread, habit tracker, etc. ^|
        echo.
    ) >> "!PRODUCT_PATH!\Listing\listing.md"
)
if "!PRODUCT_TYPE!"=="2" (
    (
        echo ---
        echo.
        echo ## Journal Details
        echo.
        echo ^| Detail ^| Value ^|
        echo ^| --- ^| --- ^|
        echo ^| Guided prompts/pages ^| ^|
        echo ^| Cover design included ^| Yes / No ^|
        echo ^| Interior page styles ^| lined / dotted / blank / prompted ^|
        echo ^| Theme/focus ^| gratitude, mindfulness, goal-setting, etc. ^|
        echo ^| Cover variations ^| ^|
        echo.
    ) >> "!PRODUCT_PATH!\Listing\listing.md"
)
if "!PRODUCT_TYPE!"=="3" (
    (
        echo ---
        echo.
        echo ## Printable Details
        echo.
        echo ^| Detail ^| Value ^|
        echo ^| --- ^| --- ^|
        echo ^| Print sizes ^| A4 / Letter / 5x7 / 8x10 ^|
        echo ^| Resolution ^| 300 DPI ^|
        echo ^| Colour mode ^| CMYK for print, RGB for digital ^|
        echo ^| Editable ^| Yes / No ^|
        echo ^| File types ^| ^|
        echo.
    ) >> "!PRODUCT_PATH!\Listing\listing.md"
)
if "!PRODUCT_TYPE!"=="4" (
    (
        echo ---
        echo.
        echo ## Workbook Details
        echo.
        echo ^| Detail ^| Value ^|
        echo ^| --- ^| --- ^|
        echo ^| Target age range ^| ^|
        echo ^| Educational focus ^| ^|
        echo ^| Number of pages ^| ^|
        echo ^| Answer key included ^| Yes / No ^|
        echo ^| Difficulty level ^| ^|
        echo ^| Curriculum alignment ^| ^|
        echo.
    ) >> "!PRODUCT_PATH!\Listing\listing.md"
)

echo  %GREEN% +%R%  listing.md

REM === tasks.md ===
(
    echo # Tasks — !FOLDER_NAME!
    echo.
    echo ## Product Checklist
    echo.
    echo - [ ] **Plan** — Decide on layout, style, and page count
    echo - [ ] **Design** — Create the design in Illustrator ^(save .ai in Source Files/^)
    echo - [ ] **Export** — Export final PDFs to Exports/ ^(check paper sizes^)
    echo - [ ] **Mockups** — Create listing mockup images ^(save in Mockups/^)
    echo - [ ] **Listing** — Fill in listing.md ^(title, description, tags^)
    echo - [ ] **Review** — Check all files, test print if possible
    echo - [ ] **Upload** — Upload to Etsy, set price, publish
    echo - [ ] **Done!** — Celebrate your new product!
) > "!PRODUCT_PATH!\tasks.md"

echo  %GREEN% +%R%  tasks.md

REM === notes.md ===
if "!PRODUCT_NAME!"=="" (
    set "DISPLAY_NAME=!PRODUCT_ID!"
) else (
    set "DISPLAY_NAME=!PRODUCT_ID! !PRODUCT_NAME!"
)

(
    echo # Design Notes — !DISPLAY_NAME!
    echo.
    echo ## Inspiration
    echo -
    echo.
    echo ## Colour Palette
    echo -
    echo.
    echo ## Fonts
    echo -
    echo.
    echo ## Competitor References
    echo -
    echo.
    echo ## Design Decisions
    echo -
    echo.
    echo ## Revision Notes
    echo -
) > "!PRODUCT_PATH!\notes.md"

echo  %GREEN% +%R%  notes.md

REM ============================================================
REM  Done!
REM ============================================================
echo.
echo.
echo  %DIM% ............................................%R%
echo  %GREEN%  Done!%R% Your new product is ready.
echo  %DIM% ............................................%R%
echo.
echo    %DIM%Folder%R%   %WHITE%!CATEGORY!\!FOLDER_NAME!\%R%
echo.
echo    %CYAN%  +-- %R%Source Files\      %CYAN%+-- %R%tasks.md
echo    %CYAN%  +-- %R%Exports\           %CYAN%+-- %R%notes.md
echo    %CYAN%  +-- %R%Mockups\           %CYAN%+-- %R%README.txt
echo    %CYAN%  +-- %R%Listing\listing.md
echo    %CYAN%  +-- %R%Assets\
echo.
echo  %DIM% ............................................%R%
echo.
echo  %YELLOW% *%R%  Next step: open %WHITE%tasks.md%R% and start
echo    working through your checklist!
echo.

REM ============================================================
REM  :End
REM ============================================================
:End
echo.
echo  %DIM% Press any key to close...%R%
pause >nul
endlocal
exit /b 0
