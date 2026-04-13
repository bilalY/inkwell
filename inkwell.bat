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

REM === Jump past subroutines to :Init ===
goto :Init

REM ============================================================
REM  SUBROUTINES
REM ============================================================

REM ------------------------------------------------------------
REM  :DrawHeader — Reusable banner with context line
REM  Set STEP="" for title-only, or STEP="1 of 5" for step mode
REM  Always set STEP_NAME before calling
REM ------------------------------------------------------------
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
if "!STEP!"=="" (
    echo  %WHITE%  !STEP_NAME!%R%
) else (
    echo  %WHITE%  Step !STEP!%R%  %DIM%-%R%  %CYAN%!STEP_NAME!%R%
)
echo  %DIM% ............................................%R%
echo.
goto :eof

REM ------------------------------------------------------------
REM  :BuildProductList — Scan all categories, populate PROD_n vars
REM ------------------------------------------------------------
:BuildProductList
set "PROD_COUNT=0"
for %%C in (Planners Journals Printables Workbooks) do (
    if exist "%SCRIPT_DIR%%%C" (
        for /d %%D in ("%SCRIPT_DIR%%%C\*") do (
            set /a PROD_COUNT+=1
            set "PROD_!PROD_COUNT!_PATH=%%D"
            set "PROD_!PROD_COUNT!_FOLDER=%%~nxD"
            set "PROD_!PROD_COUNT!_CATEGORY=%%C"
        )
    )
)
goto :eof

REM ------------------------------------------------------------
REM  :ShowProductPicker — Display numbered list, get selection
REM  Sets SELECTED_PATH, SELECTED_FOLDER, SELECTED_CATEGORY
REM  Sets PICKER_VALID=1 on success, PICKER_VALID=0 on failure
REM ------------------------------------------------------------
:ShowProductPicker
set "PICKER_VALID=0"
if !PROD_COUNT! equ 0 (
    echo  %DIM% No products found yet. Create one first!%R%
    echo.
    set /p "DUMMY= %YELLOW% >> %R% Press Enter to go back... "
    goto :eof
)

set "CURRENT_CAT="
for /l %%i in (1,1,!PROD_COUNT!) do (
    if not "!PROD_%%i_CATEGORY!"=="!CURRENT_CAT!" (
        set "CURRENT_CAT=!PROD_%%i_CATEGORY!"
        echo.
        echo  %WHITE%  !CURRENT_CAT!/%R%
    )
    echo    %CYAN%[%%i]%R%  !PROD_%%i_FOLDER!
)
echo.
set "PICK="
set /p "PICK= %YELLOW% >> %R% Pick a number (1-!PROD_COUNT!): "

REM === Validate selection ===
if "!PICK!"=="" goto :eof
set "PICKER_VALID=0"
for /l %%i in (1,1,!PROD_COUNT!) do (
    if "!PICK!"=="%%i" set "PICKER_VALID=1"
)
if "!PICKER_VALID!"=="0" (
    echo.
    echo  %RED% x%R%  Invalid selection.
    goto :eof
)

set "SELECTED_PATH=!PROD_%PICK%_PATH!"
set "SELECTED_FOLDER=!PROD_%PICK%_FOLDER!"
set "SELECTED_CATEGORY=!PROD_%PICK%_CATEGORY!"
goto :eof

REM ------------------------------------------------------------
REM  :CountTasks — Count checked/unchecked in tasks.md
REM  Call with: call :CountTasks "product_path"
REM  Sets TASKS_DONE and TASKS_TOTAL
REM ------------------------------------------------------------
:CountTasks
set "TASKS_DONE=0"
set "TASKS_TOTAL=0"
set "TASKS_UNCHECKED=0"
set "CT_PATH=%~1"
if not exist "!CT_PATH!\tasks.md" goto :eof
for /f %%n in ('findstr /c:"- [x]" "!CT_PATH!\tasks.md" 2^>nul ^| find /c /v ""') do set "TASKS_DONE=%%n"
for /f %%n in ('findstr /c:"- [ ]" "!CT_PATH!\tasks.md" 2^>nul ^| find /c /v ""') do set "TASKS_UNCHECKED=%%n"
set /a TASKS_TOTAL=TASKS_DONE+TASKS_UNCHECKED
goto :eof

REM ============================================================
REM  :Init — First-run setup
REM ============================================================
:Init
if not exist "%SCRIPT_DIR%_brand-kit.md" (
    (
        echo # Brand Kit
        echo.
        echo Your brand identity across all products. Fill this in once
        echo and refer back to it for every new design.
        echo.
        echo ---
        echo.
        echo ## Colour Palette
        echo.
        echo ^| Role ^| Hex ^| Name ^|
        echo ^| --- ^| --- ^| --- ^|
        echo ^| Primary ^| ^| ^|
        echo ^| Secondary ^| ^| ^|
        echo ^| Accent ^| ^| ^|
        echo ^| Background ^| ^| ^|
        echo ^| Text ^| ^| ^|
        echo.
        echo ---
        echo.
        echo ## Fonts
        echo.
        echo ^| Role ^| Font Name ^| Where to Get It ^|
        echo ^| --- ^| --- ^| --- ^|
        echo ^| Heading ^| ^| ^|
        echo ^| Body ^| ^| ^|
        echo ^| Accent ^| ^| ^|
        echo.
        echo ---
        echo.
        echo ## Design Guidelines
        echo.
        echo - **Style:**
        echo - **Mood:**
        echo - **Target audience:**
        echo - **Avoid:**
    ) > "%SCRIPT_DIR%_brand-kit.md"
)
goto :MainMenu

REM ============================================================
REM  :MainMenu — The hub
REM ============================================================
:MainMenu
set "STEP=" & set "STEP_NAME=Etsy Digital Product Setup Tool" & call :DrawHeader

echo  %DIM% What would you like to do?%R%
echo.
echo    %CYAN%[1]%R%  Create New Product
echo    %CYAN%[2]%R%  My Products
echo    %CYAN%[3]%R%  Open Product Folder
echo    %CYAN%[4]%R%  Pre-Listing Check
echo    %CYAN%[5]%R%  Package for Etsy
echo.
echo    %DIM%[6]%R%  %DIM%Exit%R%
echo.
set "MENU_CHOICE="
set /p "MENU_CHOICE= %YELLOW% >> %R% Pick a number (1-6): "

if "!MENU_CHOICE!"=="1" goto :ChooseType
if "!MENU_CHOICE!"=="2" goto :Dashboard
if "!MENU_CHOICE!"=="3" goto :OpenProduct
if "!MENU_CHOICE!"=="4" goto :PreListingCheck
if "!MENU_CHOICE!"=="5" goto :PackageForEtsy
if "!MENU_CHOICE!"=="6" goto :End

echo.
echo  %RED% x%R%  Pick 1 to 6!
pause >nul
goto :MainMenu

REM ============================================================
REM  CREATE FLOW
REM ============================================================

REM ------------------------------------------------------------
REM  Step 1 of 5: Choose Product Type
REM ------------------------------------------------------------
:ChooseType
set "STEP=1 of 5" & set "STEP_NAME=Choose Product Type" & call :DrawHeader

echo  %WHITE% What type of product are you creating?%R%
echo.
echo    %CYAN%[1]%R%  Planner
echo    %CYAN%[2]%R%  Journal
echo    %CYAN%[3]%R%  Printable
echo    %CYAN%[4]%R%  Workbook
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
echo  %RED% x%R%  That's not one of the options - pick 1 to 4!
pause >nul
goto :ChooseType

REM ------------------------------------------------------------
REM  Auto-number (silent)
REM ------------------------------------------------------------
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

REM ------------------------------------------------------------
REM  Step 2 of 5: Name Your Product
REM ------------------------------------------------------------
:EnterName
set "STEP=2 of 5" & set "STEP_NAME=Name Your Product" & call :DrawHeader

echo  %GREEN% *%R%  Type: %WHITE%!TYPE_NAME!%R%
echo  %GREEN% *%R%  Next number: %BOLD%%WHITE%!PRODUCT_ID!%R%
echo.
echo  %DIM% Give your product a name, or press Enter%R%
echo  %DIM% to skip and just use the number.%R%
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

REM ------------------------------------------------------------
REM  Step 3 of 5: Confirm
REM ------------------------------------------------------------
:Confirm
set "STEP=3 of 5" & set "STEP_NAME=Confirm" & call :DrawHeader

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
echo    %DIM%  Listing\  Assets\  README.md%R%
echo    %DIM%  tasks.md  notes.md  listing.md  license.txt%R%
echo.

set "CONFIRM="
set /p "CONFIRM= %YELLOW% >> %R% Look good? (%GREEN%Y%R%/%RED%N%R%): "

if /i "!CONFIRM!"=="Y" goto :CreateAll
if /i "!CONFIRM!"=="N" (
    echo.
    echo  %DIM% No worries! Back to the menu.%R%
    timeout /t 1 >nul
    goto :MainMenu
)
echo.
echo  %RED% x%R%  Please type Y or N.
pause >nul
goto :Confirm

REM ------------------------------------------------------------
REM  Step 4 of 5: Creating Product
REM ------------------------------------------------------------
:CreateAll
set "STEP=4 of 5" & set "STEP_NAME=Creating Product" & call :DrawHeader

echo  %DIM% Setting up !FOLDER_NAME!...%R%
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

REM === README.md ===
(
    echo # !FOLDER_NAME!
    echo.
    echo **Type:** !TYPE_NAME!
    echo **Created:** !TODAY!
    echo.
    echo ---
    echo.
    echo This folder was created by Inkwell.
    echo.
    echo ## Folder Guide
    echo.
    echo ^| Folder ^| What Goes Here ^|
    echo ^| --- ^| --- ^|
    echo ^| **Source Files/** ^| Your working .ai ^(Illustrator^) files. Save versions as you go. ^|
    echo ^| **Exports/** ^| Final PDFs and print-ready files for buyers. ^|
    echo ^| **Mockups/** ^| Product images for your Etsy listing ^(flat lay, on desk, etc.^). ^|
    echo ^| **Listing/** ^| Your Etsy listing copy. Open listing.md and fill it in. ^|
    echo ^| **Assets/** ^| Fonts, colour palettes, graphics, and inspiration. ^|
    echo.
) > "!PRODUCT_PATH!\README.md"

if "!PRODUCT_TYPE!"=="1" (
    (
        echo ---
        echo.
        echo ## Tips for Planners
        echo.
        echo - A5 and Letter are the most popular sizes on Etsy
        echo - Consider offering both dated and undated versions
        echo - Include a binding margin if buyers might print and bind
        echo - Weekly, monthly, and daily spreads sell well together
        echo - Undated planners have a longer shelf life
    ) >> "!PRODUCT_PATH!\README.md"
)
if "!PRODUCT_TYPE!"=="2" (
    (
        echo ---
        echo.
        echo ## Tips for Journals
        echo.
        echo - The cover design is what buyers see first - make it stand out
        echo - Write your prompts in a separate document before designing
        echo - Test that interior pages print cleanly in colour and greyscale
        echo - Guided journals with a clear theme sell better than generic ones
        echo - Consider including a "how to use this journal" intro page
    ) >> "!PRODUCT_PATH!\README.md"
)
if "!PRODUCT_TYPE!"=="3" (
    (
        echo ---
        echo.
        echo ## Tips for Printables
        echo.
        echo - Always design at 300 DPI for sharp printing
        echo - Use CMYK colour mode for print files, RGB for digital-only
        echo - Offer multiple sizes ^(A4 and Letter at minimum^)
        echo - Wall art should include a bleed area for trimming
        echo - Show mockups of the printable framed or in a real setting
    ) >> "!PRODUCT_PATH!\README.md"
)
if "!PRODUCT_TYPE!"=="4" (
    (
        echo ---
        echo.
        echo ## Tips for Workbooks
        echo.
        echo - Clearly state the target age range in your listing
        echo - Include an answer key - parents and teachers expect it
        echo - Test your activities with someone in the target age group
        echo - Progressive difficulty keeps children engaged
        echo - Consider including a progress tracker or reward page
    ) >> "!PRODUCT_PATH!\README.md"
)
echo  %GREEN% +%R%  README.md

REM === listing.md ===
(
    echo # Etsy Listing - !FOLDER_NAME!
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
    echo ^> List every file the buyer will receive
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
        echo ^| Key features ^| ^|
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
        echo ^| Theme/focus ^| ^|
        echo ^| Cover variations ^| ^|
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
    ) >> "!PRODUCT_PATH!\Listing\listing.md"
)
echo  %GREEN% +%R%  listing.md

REM === tasks.md ===
(
    echo # Tasks - !FOLDER_NAME!
    echo.
    echo ## Product Checklist
    echo.
    echo - [ ] **Plan** - Decide on layout, style, and page count
    echo - [ ] **Design** - Create the design in Illustrator ^(save .ai in Source Files/^)
    echo - [ ] **Export** - Export final PDFs to Exports/ ^(check paper sizes^)
    echo - [ ] **Mockups** - Create listing mockup images ^(save in Mockups/^)
    echo - [ ] **Listing** - Fill in listing.md ^(title, description, tags^)
    echo - [ ] **Review** - Check all files, test print if possible
    echo - [ ] **Upload** - Upload to Etsy, set price, publish
    echo - [ ] **Done!** - Celebrate your new product!
) > "!PRODUCT_PATH!\tasks.md"
echo  %GREEN% +%R%  tasks.md

REM === notes.md ===
if "!PRODUCT_NAME!"=="" (
    set "DISPLAY_NAME=!PRODUCT_ID!"
) else (
    set "DISPLAY_NAME=!PRODUCT_ID! !PRODUCT_NAME!"
)

(
    echo # Design Notes - !DISPLAY_NAME!
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
    echo.
    echo ---
    echo.
    echo ^> See **_brand-kit.md** in your Etsy Products folder for
    echo ^> your brand colours and fonts.
) > "!PRODUCT_PATH!\notes.md"
echo  %GREEN% +%R%  notes.md

REM === license.txt ===
(
    echo ========================================
    echo   LICENSE - PERSONAL USE
    echo ========================================
    echo.
    echo Thank you for purchasing this digital
    echo product!
    echo.
    echo By downloading this file, you agree to
    echo the following terms:
    echo.
    echo.
    echo PERMITTED:
    echo.
    echo   * Print unlimited copies for your own
    echo     personal use
    echo.
    echo   * Use in your personal planner, journal,
    echo     or binder
    echo.
    echo.
    echo NOT PERMITTED:
    echo.
    echo   * Resell, redistribute, or share this
    echo     file with others
    echo.
    echo   * Upload to any website or file-sharing
    echo     platform
    echo.
    echo   * Claim this design as your own
    echo.
    echo   * Use for commercial purposes without a
    echo     separate commercial license
    echo.
    echo.
    echo For commercial licensing enquiries, please
    echo contact the seller through Etsy.
    echo.
    echo All rights reserved.
    echo.
) > "!PRODUCT_PATH!\license.txt"
echo  %GREEN% +%R%  license.txt

REM ------------------------------------------------------------
REM  Step 5 of 5: Done!
REM ------------------------------------------------------------
:CreateDone
set "STEP=5 of 5" & set "STEP_NAME=Done!" & call :DrawHeader

echo  %GREEN%  Your new product is ready!%R%
echo.
echo    %DIM%Folder%R%   %WHITE%!CATEGORY!\!FOLDER_NAME!\%R%
echo.
echo    %CYAN%  +-- %R%Source Files\      %CYAN%+-- %R%tasks.md
echo    %CYAN%  +-- %R%Exports\           %CYAN%+-- %R%notes.md
echo    %CYAN%  +-- %R%Mockups\           %CYAN%+-- %R%README.md
echo    %CYAN%  +-- %R%Listing\listing.md %CYAN%+-- %R%license.txt
echo    %CYAN%  +-- %R%Assets\
echo.
echo  %DIM% ............................................%R%
echo.

REM --- Open folder prompt ---
set "OPEN_NOW="
set /p "OPEN_NOW= %YELLOW% >> %R% Open the folder now? (%GREEN%Y%R%/%RED%N%R%): "
if /i "!OPEN_NOW!"=="Y" (
    explorer.exe "!PRODUCT_PATH!"
)

echo.
set "CREATE_AGAIN="
set /p "CREATE_AGAIN= %YELLOW% >> %R% Create another product? (%GREEN%Y%R%/%RED%N%R%): "
if /i "!CREATE_AGAIN!"=="Y" goto :ChooseType

goto :MainMenu

REM ============================================================
REM  DASHBOARD
REM ============================================================
:Dashboard
set "STEP=" & set "STEP_NAME=My Products" & call :DrawHeader
call :BuildProductList

if !PROD_COUNT! equ 0 (
    echo  %DIM% No products found yet. Create one first!%R%
    echo.
    set /p "DUMMY= %YELLOW% >> %R% Press Enter to go back... "
    goto :MainMenu
)

set "TOTAL_READY=0"
set "TOTAL_PROGRESS=0"
set "TOTAL_NOT_STARTED=0"
set "CURRENT_CAT="

for /l %%i in (1,1,!PROD_COUNT!) do (
    REM === Category header ===
    if not "!PROD_%%i_CATEGORY!"=="!CURRENT_CAT!" (
        set "CURRENT_CAT=!PROD_%%i_CATEGORY!"
        echo.
        echo  %WHITE%  !CURRENT_CAT!/%R%
    )

    REM === Count tasks ===
    call :CountTasks "!PROD_%%i_PATH!"

    REM === Build progress bar (8 chars) ===
    set "BAR=........"
    set "BAR_COLOUR=!DIM!"
    if !TASKS_TOTAL! gtr 0 (
        set /a "FILLED=TASKS_DONE*8/TASKS_TOTAL"
        set "BAR="
        for /l %%j in (1,1,8) do (
            if %%j leq !FILLED! (
                set "BAR=!BAR!#"
            ) else (
                set "BAR=!BAR!."
            )
        )

        if !TASKS_DONE! equ !TASKS_TOTAL! (
            set /a TOTAL_READY+=1
            set "BAR_COLOUR=!GREEN!"
            echo    !PROD_%%i_FOLDER!  !GREEN![!BAR!] !TASKS_DONE!/!TASKS_TOTAL!  Ready!!R!
        ) else if !TASKS_DONE! gtr 0 (
            set /a TOTAL_PROGRESS+=1
            set "BAR_COLOUR=!YELLOW!"
            echo    !PROD_%%i_FOLDER!  !YELLOW![!BAR!] !TASKS_DONE!/!TASKS_TOTAL!!R!
        ) else (
            set /a TOTAL_NOT_STARTED+=1
            echo    !PROD_%%i_FOLDER!  !DIM![!BAR!] !TASKS_DONE!/!TASKS_TOTAL!!R!
        )
    ) else (
        set /a TOTAL_NOT_STARTED+=1
        echo    !PROD_%%i_FOLDER!  !DIM![........] --!R!
    )
)

echo.
echo  %DIM% ............................................%R%
echo  %WHITE%  !PROD_COUNT! products%R%  %DIM%^|%R%  %GREEN%!TOTAL_READY! ready%R%  %DIM%^|%R%  %YELLOW%!TOTAL_PROGRESS! in progress%R%  %DIM%^|%R%  %DIM%!TOTAL_NOT_STARTED! not started%R%
echo  %DIM% ............................................%R%
echo.
set /p "DUMMY= %YELLOW% >> %R% Press Enter to go back... "
goto :MainMenu

REM ============================================================
REM  OPEN PRODUCT FOLDER
REM ============================================================
:OpenProduct
set "STEP=" & set "STEP_NAME=Open Product Folder" & call :DrawHeader
call :BuildProductList
call :ShowProductPicker
if "!PICKER_VALID!"=="0" goto :MainMenu

echo.
echo  %GREEN% *%R%  Opening %WHITE%!SELECTED_FOLDER!%R% in Explorer...
explorer.exe "!SELECTED_PATH!"
timeout /t 2 >nul
goto :MainMenu

REM ============================================================
REM  PRE-LISTING CHECK
REM ============================================================
:PreListingCheck
set "STEP=" & set "STEP_NAME=Pre-Listing Check" & call :DrawHeader
call :BuildProductList
call :ShowProductPicker
if "!PICKER_VALID!"=="0" goto :MainMenu

REM === Show results screen ===
set "STEP=" & set "STEP_NAME=Checking: !SELECTED_FOLDER!" & call :DrawHeader

set "PASS_COUNT=0"
set "FAIL_COUNT=0"

REM --- Check 1: Exports/ has files ---
set "HAS_EXPORTS=0"
if exist "!SELECTED_PATH!\Exports\*" (
    for %%F in ("!SELECTED_PATH!\Exports\*") do set "HAS_EXPORTS=1"
)
if !HAS_EXPORTS! equ 1 (
    echo  %GREEN%  [PASS]%R%  Exports/ has files
    set /a PASS_COUNT+=1
) else (
    echo  %RED%  [FAIL]%R%  Exports/ is empty
    set /a FAIL_COUNT+=1
)

REM --- Check 2: Mockups/ has files ---
set "HAS_MOCKUPS=0"
if exist "!SELECTED_PATH!\Mockups\*" (
    for %%F in ("!SELECTED_PATH!\Mockups\*") do set "HAS_MOCKUPS=1"
)
if !HAS_MOCKUPS! equ 1 (
    echo  %GREEN%  [PASS]%R%  Mockups/ has images
    set /a PASS_COUNT+=1
) else (
    echo  %RED%  [FAIL]%R%  Mockups/ is empty
    set /a FAIL_COUNT+=1
)

REM --- Check 3: listing.md has been filled in ---
set "LISTING_OK=0"
if exist "!SELECTED_PATH!\Listing\listing.md" (
    for %%F in ("!SELECTED_PATH!\Listing\listing.md") do (
        if %%~zF gtr 1500 set "LISTING_OK=1"
    )
)
if !LISTING_OK! equ 1 (
    echo  %GREEN%  [PASS]%R%  listing.md has been filled in
    set /a PASS_COUNT+=1
) else (
    echo  %RED%  [FAIL]%R%  listing.md looks like the default template
    set /a FAIL_COUNT+=1
)

REM --- Check 4: license.txt exists ---
if exist "!SELECTED_PATH!\license.txt" (
    echo  %GREEN%  [PASS]%R%  license.txt exists
    set /a PASS_COUNT+=1
) else (
    echo  %RED%  [FAIL]%R%  license.txt is missing
    set /a FAIL_COUNT+=1
)

REM --- Check 5: All tasks complete ---
call :CountTasks "!SELECTED_PATH!"
if !TASKS_TOTAL! gtr 0 (
    if !TASKS_DONE! equ !TASKS_TOTAL! (
        echo  %GREEN%  [PASS]%R%  All tasks complete ^(!TASKS_DONE!/!TASKS_TOTAL!^)
        set /a PASS_COUNT+=1
    ) else (
        echo  %RED%  [FAIL]%R%  Tasks incomplete ^(!TASKS_DONE!/!TASKS_TOTAL!^)
        set /a FAIL_COUNT+=1
    )
) else (
    echo  %RED%  [FAIL]%R%  No tasks found
    set /a FAIL_COUNT+=1
)

echo.
echo  %DIM% ............................................%R%
if !FAIL_COUNT! equ 0 (
    echo  %GREEN%  ALL CHECKS PASSED%R%
    echo  %DIM%  Ready to list on Etsy!%R%
) else (
    echo  %RED%  !FAIL_COUNT! check^(s^) failed%R%  %DIM%- not ready yet%R%
)
echo  %DIM% ............................................%R%
echo.
set /p "DUMMY= %YELLOW% >> %R% Press Enter to go back... "
goto :MainMenu

REM ============================================================
REM  PACKAGE FOR ETSY (ZIP)
REM ============================================================
:PackageForEtsy
set "STEP=" & set "STEP_NAME=Package for Etsy" & call :DrawHeader
call :BuildProductList
call :ShowProductPicker
if "!PICKER_VALID!"=="0" goto :MainMenu

REM === Check Exports/ has files ===
set "HAS_EXPORTS=0"
if exist "!SELECTED_PATH!\Exports\*" (
    for %%F in ("!SELECTED_PATH!\Exports\*") do set "HAS_EXPORTS=1"
)
if !HAS_EXPORTS! equ 0 (
    echo.
    echo  %RED% x%R%  Exports/ is empty - nothing to package!
    echo  %DIM%   Add your final files to Exports/ first.%R%
    echo.
    set /p "DUMMY= %YELLOW% >> %R% Press Enter to go back... "
    goto :MainMenu
)

REM === Show Exports contents ===
set "STEP=" & set "STEP_NAME=Package: !SELECTED_FOLDER!" & call :DrawHeader

echo  %WHITE% Files in Exports/:%R%
echo.
set "FILE_COUNT=0"
for %%F in ("!SELECTED_PATH!\Exports\*") do (
    set /a FILE_COUNT+=1
    echo    %CYAN%*%R%  %%~nxF
)
echo.
echo  %DIM% !FILE_COUNT! file^(s^) will be zipped.%R%
echo  %DIM% Etsy allows up to 5 files per listing, max 20 MB each.%R%
echo  %DIM% Zip everything into one file if you have more than 5.%R%
echo.

REM === Get zip filename ===
set "ZIP_NAME=!SELECTED_FOLDER!"
set "ZIP_INPUT="
set /p "ZIP_INPUT= %YELLOW% >> %R% Zip filename [%WHITE%!ZIP_NAME!%R%]: "
if not "!ZIP_INPUT!"=="" set "ZIP_NAME=!ZIP_INPUT!"

set "ZIP_PATH=!SELECTED_PATH!\!ZIP_NAME!.zip"

REM === Delete existing zip if present ===
if exist "!ZIP_PATH!" del "!ZIP_PATH!" >nul 2>nul

echo.
echo  %DIM% Zipping...%R%

powershell -command "Compress-Archive -Path '!SELECTED_PATH!\Exports\*' -DestinationPath '!ZIP_PATH!' -Force" 2>nul

if not exist "!ZIP_PATH!" (
    echo.
    echo  %RED% x%R%  Failed to create zip file!
    echo  %DIM%   Make sure PowerShell is available.%R%
    echo.
    set /p "DUMMY= %YELLOW% >> %R% Press Enter to go back... "
    goto :MainMenu
)

REM === Show result ===
for %%F in ("!ZIP_PATH!") do set "ZIP_SIZE=%%~zF"
set /a ZIP_KB=ZIP_SIZE/1024
set /a ZIP_MB=ZIP_SIZE/1048576

echo.
echo  %GREEN% +%R%  Created: %WHITE%!ZIP_NAME!.zip%R%
echo    %DIM%Size: !ZIP_KB! KB%R%

if !ZIP_MB! geq 20 (
    echo.
    echo  %RED% !!%R%  WARNING: File is over 20 MB!
    echo  %DIM%   Etsy's limit is 20 MB per file.%R%
    echo  %DIM%   Consider reducing file sizes or splitting.%R%
) else (
    echo    %GREEN%*%R%  %DIM%Within Etsy's 20 MB limit%R%
)

echo.
echo  %DIM% ............................................%R%
echo.

REM === Open folder prompt ===
set "OPEN_ZIP="
set /p "OPEN_ZIP= %YELLOW% >> %R% Open the folder? (%GREEN%Y%R%/%RED%N%R%): "
if /i "!OPEN_ZIP!"=="Y" (
    explorer.exe "!SELECTED_PATH!"
)

echo.
set /p "DUMMY= %YELLOW% >> %R% Press Enter to go back... "
goto :MainMenu

REM ============================================================
REM  :End — Clean exit
REM ============================================================
:End
echo.
echo  %DIM% Goodbye! Happy creating.%R%
echo.
timeout /t 2 >nul
endlocal
exit /b 0
