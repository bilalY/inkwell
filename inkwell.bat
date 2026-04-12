@echo off
setlocal enabledelayedexpansion

REM === Script directory (where inkwell.bat lives) ===
set "SCRIPT_DIR=%~dp0"

REM === Today's date ===
set "TODAY=%date%"

REM ============================================================
REM  :Welcome — Banner and introduction
REM ============================================================
:Welcome
cls
echo.
echo   +======================================+
echo   :                                      :
echo   :           I N K W E L L              :
echo   :     Etsy Product Setup Tool          :
echo   :                                      :
echo   +======================================+
echo.
echo   Create a new product folder with everything
echo   you need to design, export, and list on Etsy.
echo.
echo   ========================================
echo.

REM ============================================================
REM  :ChooseType — Product type selection
REM ============================================================
:ChooseType
echo   What type of product are you creating?
echo.
echo     1) Planner
echo     2) Journal
echo     3) Printable
echo     4) Workbook
echo.
set "PRODUCT_TYPE="
set /p "PRODUCT_TYPE=  Pick a number (1-4): "

REM === Validate type selection ===
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
echo   That's not one of the options — pick a number from 1 to 4!
echo.
goto :ChooseType

REM ============================================================
REM  :AutoNumber — Count existing products and assign next number
REM ============================================================
:AutoNumber
set "CATEGORY_PATH=%SCRIPT_DIR%%CATEGORY%"

REM === Create category folder if it doesn't exist ===
if not exist "!CATEGORY_PATH!" mkdir "!CATEGORY_PATH!"

REM === Count existing product folders matching PREFIX-* ===
set "COUNT=0"
for /d %%D in ("!CATEGORY_PATH!\!PREFIX!-*") do set /a COUNT+=1

REM === Calculate next number with zero-padding to 3 digits ===
set /a NEXT=COUNT+1
if !NEXT! lss 10 (
    set "NUM=00!NEXT!"
) else if !NEXT! lss 100 (
    set "NUM=0!NEXT!"
) else (
    set "NUM=!NEXT!"
)

set "PRODUCT_ID=!PREFIX!-!NUM!"

echo.
echo   Next available number: !PRODUCT_ID!
echo.

REM ============================================================
REM  :EnterName — Optional product name
REM ============================================================
:EnterName
set "PRODUCT_NAME="
set /p "PRODUCT_NAME=  Give it a name (or press Enter to skip): "

REM === Build the folder name ===
if "!PRODUCT_NAME!"=="" (
    set "FOLDER_NAME=!PRODUCT_ID!"
) else (
    set "FOLDER_NAME=!PRODUCT_ID! - !PRODUCT_NAME!"
)

set "PRODUCT_PATH=!CATEGORY_PATH!\!FOLDER_NAME!"

REM === Check if folder already exists ===
if exist "!PRODUCT_PATH!" (
    echo.
    echo   A folder called "!FOLDER_NAME!" already exists!
    echo   Please choose a different name.
    echo.
    goto :EnterName
)

REM ============================================================
REM  :Confirm — Show summary and ask for confirmation
REM ============================================================
:Confirm
echo.
echo   ========================================
echo   Here's what will be created:
echo.
echo     Type:     !TYPE_NAME!
echo     ID:       !PRODUCT_ID!
if not "!PRODUCT_NAME!"=="" (
    echo     Name:     !PRODUCT_NAME!
)
echo     Folder:   !CATEGORY!\!FOLDER_NAME!
echo   ========================================
echo.

set "CONFIRM="
set /p "CONFIRM=  Look good? (Y/N): "

if /i "!CONFIRM!"=="Y" goto :CreateFolders
if /i "!CONFIRM!"=="N" (
    echo.
    echo   No worries! Run the script again when you're ready.
    goto :End
)
echo.
echo   Please type Y or N.
goto :Confirm

REM ============================================================
REM  :CreateFolders — Create the directory structure
REM ============================================================
:CreateFolders
echo.
echo   Creating folders...

mkdir "!PRODUCT_PATH!\Source Files" 2>nul
if !ERRORLEVEL! neq 0 (
    echo.
    echo   ERROR: Could not create folders. Check you have permission to write here.
    goto :End
)
mkdir "!PRODUCT_PATH!\Exports" 2>nul
mkdir "!PRODUCT_PATH!\Mockups" 2>nul
mkdir "!PRODUCT_PATH!\Listing" 2>nul
mkdir "!PRODUCT_PATH!\Assets" 2>nul

REM ============================================================
REM  :CreateReadme — README.txt with folder guide
REM ============================================================
:CreateReadme
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
    echo   Listing/        Your Etsy listing copy. Open listing.txt and fill it in.
    echo.
    echo   Assets/         Fonts, colour palettes, graphics, and inspiration.
    echo                   Keep track of what you used so you can reuse it later.
    echo.
) > "!PRODUCT_PATH!\README.txt"

REM === Append type-specific tips ===
if "!PRODUCT_TYPE!"=="1" (
    (
        echo ========================================
        echo TIPS FOR PLANNERS:
        echo.
        echo   - A5 and Letter are the most popular sizes on Etsy
        echo   - Consider offering both dated and undated versions
        echo   - Include a binding margin if buyers might print and bind
        echo   - Weekly, monthly, and daily spreads sell well together
        echo   - Undated planners have a longer shelf life — no need to update yearly
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
        echo   - Test that interior pages print cleanly in both colour and greyscale
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
        echo   - Offer multiple sizes ^(A4 and Letter at minimum^) to reach more buyers
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
        echo   - Test your activities with someone in the target age group if possible
        echo   - Progressive difficulty keeps children engaged
        echo   - Consider including a progress tracker or reward page
        echo.
    ) >> "!PRODUCT_PATH!\README.txt"
)

REM ============================================================
REM  :CreateListing — listing.txt with guided Etsy prompts
REM ============================================================
:CreateListing
(
    echo ========================================
    echo   ETSY LISTING TEMPLATE
    echo   Product: !FOLDER_NAME!
    echo   Type: !TYPE_NAME!
    echo   Created: !TODAY!
    echo ========================================
    echo.
    echo.
    echo --- PRODUCT TITLE ---
    echo.
    echo Write your title here. Etsy allows 140 characters.
    echo Tips:
    echo   - Put your most important keywords first
    echo   - Include what it is + who it's for + a key feature
    echo   - Example: "Daily Planner Printable ^| A5 Undated ^| Minimalist Design"
    echo.
    echo Title:
    echo.
    echo.
    echo --- DESCRIPTION ---
    echo.
    echo Answer these questions to write your description:
    echo.
    echo   1. What is this product?
    echo      ^(e.g. "A 12-month undated daily planner..."^)
    echo.
    echo   2. Who is it for?
    echo      ^(e.g. "Perfect for busy professionals who..."^)
    echo.
    echo   3. What's included in the download?
    echo      ^(e.g. "You'll receive 3 PDF files..."^)
    echo.
    echo   4. How do they use it?
    echo      ^(e.g. "Simply download, print at home or at a print shop..."^)
    echo.
    echo Description:
    echo.
    echo.
    echo --- TAGS ---
    echo.
    echo Etsy allows up to 13 tags. Use all 13!
    echo Think about what a buyer would search for.
    echo.
    echo    1.
    echo    2.
    echo    3.
    echo    4.
    echo    5.
    echo    6.
    echo    7.
    echo    8.
    echo    9.
    echo   10.
    echo   11.
    echo   12.
    echo   13.
    echo.
    echo.
    echo --- PRICING NOTES ---
    echo.
    echo   Your price:
    echo   Competitor price range:
    echo   Notes:
    echo.
    echo.
    echo --- FILE FORMATS INCLUDED ---
    echo.
    echo   List every file the buyer will receive:
    echo   ^(e.g. PDF - A4, PDF - Letter, PNG 300 DPI^)
    echo.
    echo   1.
    echo   2.
    echo   3.
    echo.
) > "!PRODUCT_PATH!\Listing\listing.txt"

REM === Append type-specific details ===
if "!PRODUCT_TYPE!"=="1" (
    (
        echo.
        echo --- PLANNER-SPECIFIC DETAILS ---
        echo.
        echo   Page count:
        echo   Date range:          ^(dated / undated^)
        echo   Paper sizes included: ^(A4 / A5 / Letter / Half Letter^)
        echo   Orientation:         ^(portrait / landscape^)
        echo   Binding margin:      ^(Yes / No^)
        echo   Key features:        ^(monthly overview, weekly spread, habit tracker, etc.^)
        echo.
    ) >> "!PRODUCT_PATH!\Listing\listing.txt"
)
if "!PRODUCT_TYPE!"=="2" (
    (
        echo.
        echo --- JOURNAL-SPECIFIC DETAILS ---
        echo.
        echo   Number of guided prompts/pages:
        echo   Cover design included:  ^(Yes / No^)
        echo   Interior page styles:   ^(lined / dotted / blank / prompted^)
        echo   Theme/focus:            ^(gratitude, mindfulness, goal-setting, etc.^)
        echo   Cover variations:       ^(list any colour or style options^)
        echo.
    ) >> "!PRODUCT_PATH!\Listing\listing.txt"
)
if "!PRODUCT_TYPE!"=="3" (
    (
        echo.
        echo --- PRINTABLE-SPECIFIC DETAILS ---
        echo.
        echo   Print sizes included:  ^(A4 / Letter / 5x7 / 8x10 / etc.^)
        echo   Resolution:            300 DPI ^(required for print quality^)
        echo   Colour mode:           CMYK for print, RGB for digital display
        echo   Editable:              ^(Yes / No — if so, which tool?^)
        echo   Instant download:      ^(list all file types^)
        echo.
    ) >> "!PRODUCT_PATH!\Listing\listing.txt"
)
if "!PRODUCT_TYPE!"=="4" (
    (
        echo.
        echo --- WORKBOOK-SPECIFIC DETAILS ---
        echo.
        echo   Target age range:
        echo   Educational focus/subject:
        echo   Number of pages/activities:
        echo   Answer key included:   ^(Yes / No^)
        echo   Difficulty level:
        echo   Curriculum alignment:  ^(if applicable^)
        echo.
    ) >> "!PRODUCT_PATH!\Listing\listing.txt"
)

REM ============================================================
REM  :CreateTasks — tasks.md with product checklist
REM ============================================================
:CreateTasks
(
    echo # Tasks — !FOLDER_NAME!
    echo.
    echo ## Product Checklist
    echo.
    echo - [ ] **Plan** — Decide on layout, style, and page count
    echo - [ ] **Design** — Create the design in Illustrator ^(save .ai in Source Files/^)
    echo - [ ] **Export** — Export final PDFs to Exports/ ^(check paper sizes^)
    echo - [ ] **Mockups** — Create listing mockup images ^(save in Mockups/^)
    echo - [ ] **Listing** — Fill in listing.txt ^(title, description, tags^)
    echo - [ ] **Review** — Check all files, test print if possible
    echo - [ ] **Upload** — Upload to Etsy, set price, publish
    echo - [ ] **Done!** — Celebrate your new product!
) > "!PRODUCT_PATH!\tasks.md"

REM ============================================================
REM  :CreateNotes — notes.md with design notes template
REM ============================================================
:CreateNotes

REM === Build display name for notes header ===
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

REM ============================================================
REM  :Summary — Print what was created
REM ============================================================
:Summary
echo.
echo   ========================================
echo   Done! Here's what was created:
echo   ========================================
echo.
echo   !CATEGORY!\!FOLDER_NAME!\
echo     +-- Source Files\
echo     +-- Exports\
echo     +-- Mockups\
echo     +-- Listing\
echo     :   +-- listing.txt
echo     +-- Assets\
echo     +-- README.txt
echo     +-- tasks.md
echo     +-- notes.md
echo.
echo   ========================================
echo   Next step: Open listing.txt and start
echo   filling in your Etsy listing details!
echo   ========================================
echo.

REM ============================================================
REM  :End — Clean exit
REM ============================================================
:End
echo.
echo   Press any key to close...
pause >nul
endlocal
exit /b 0
