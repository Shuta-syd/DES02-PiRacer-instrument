# :robot: Automation
**Table of contents**
- [:robot: Automation](#robot-automation)
  - [:crossed\_swords: Cross Compile Automation](#crossed_swords-cross-compile-automation)
    - [💡 Issue](#-issue)
    - [🙌 How to solve](#-how-to-solve)
    - [🏃 Progress](#-progress)
    - [:eyeglasses: TODO](#eyeglasses-todo)
  - [:gear: System Automation](#gear-system-automation)

<hr>

## :crossed_swords: Cross Compile Automation
### 💡 Issue
1. **Installing Cross-Compile environment to non-ubuntu system is not easy**.
2. **Because of this, there was a complicated process to launch our dashboard**.
   - make changes from personal workstation, push to the git repository
   - receive the commit from main workstation
   - make a binary(executable) file by Cross-Compilter of QT-Creator in main workstation
   - push to the git
   - receive the commit in raspberry pi
   - run the executable file
### 🙌 How to solve
- Make a shell script that cross-compile and generate the binary file
- Launch the script by ssh in Git Action, so make every commit will compile it and generate binary file.
> [!NOTE]
> cross-compile must be handled only in terminal, not by qt-creator gui app.
### 🏃 Progress
### :eyeglasses: TODO

## :gear: System Automation
