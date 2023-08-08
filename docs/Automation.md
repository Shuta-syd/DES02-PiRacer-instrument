# :robot: Automation
**Table of contents**
- [:robot: Automation](#robot-automation)
  - [⚔️ Cross Compile Automation](#️-cross-compile-automation)
    - [💡 Issue](#-issue)
    - [🙌 How to solve (idea)](#-how-to-solve-idea)
    - [🏃 Progress](#-progress)
    - [👓 TODO](#-todo)
  - [⚙️ System Automation](#️-system-automation)

<hr>

## ⚔️ Cross Compile Automation
### 💡 Issue
1. **Installing Cross-Compile environment to non-ubuntu system is not easy**.
2. **Because of this, there was a complicated process to launch our dashboard**.
   - make changes from personal workstation, push to the git repository
   - receive the commit from main workstation
   - make a binary(executable) file by Cross-Compilter of QT-Creator in main workstation
   - push to the git
   - receive the commit in raspberry pi
   - run the executable file
### 🙌 How to solve (idea)
- Make a shell script that cross-compile and generate the binary file
- Launch the script by ssh in Git Action, so make every commit will compile it and generate binary file.
> [!NOTE]
> cross-compile must be handled only in terminal, not by qt-creator gui app.
### 🏃 Progress
1. QT Compile by Terminal
   ```shell
   qmake $PROJECT_NAME.pro  # generate Makefile automatically
   make                     # launch Makefile
   ```
2. make it as a shell file
   - [build.sh](/app/dashboard/build.sh)
    ```shell
    # !/bin/bash
    ./clean.sh
    qmake dashboard.pro
    make
    ./dashboard
    ```
   - [clean.sh](/app/dashboard/clean.sh)
    ```
    rm -rf qrc*
    rm -rf *.o
    rm -rf dashboard
    rm -rf Makefile
    rm -rf qmake.stash
    rm -rf *clangd
    ```
    > [!WARNING]
    > Actually, this is not a Cross-Compile. You must run this code at the raspy, and this will be unefficient if the project is heavy.

### 👓 TODO
- Find how to **cross-compile** inside of terminal.
  [my tries with GPT](https://chat.openai.com/share/24254058-281d-412b-86ad-0b2e5afa12f6)

## ⚙️ System Automation