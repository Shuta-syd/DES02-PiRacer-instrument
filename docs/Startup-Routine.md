## RPi Start-up routine 
### Intro
On UNIX Systems there are several several approaches to achieve a "Start-Up-Routine" , depending on the specific needs and the Unix flavor you are using (e.g., Linux, macOS, Rasbrian). 
Common methods are: 

    Startup Scripts (init.d or systemd):
        System V Init (init.d): On older Unix systems like CentOS 6 or Debian 7, you can create startup scripts in the /etc/init.d/ directory. These scripts typically include start, stop, and restart commands for your services. Use the chkconfig or update-rc.d command to manage their runlevels.
        Systemd: On modern Linux distributions like Ubuntu 16.04+ or CentOS 7+, systemd is the init system. You can create unit files in /etc/systemd/system/ or /lib/systemd/system/. Use systemctl to enable, start, stop, or manage services.

    Cron Jobs:
        You can use the cron scheduler to run scripts or commands at specific times or intervals. Use the crontab command to edit the user-specific cron jobs or add scripts to the /etc/cron.d/ directory for system-wide tasks.

    User-Specific Startup Scripts:
        For tasks that should run when a user logs in, you can add commands or scripts to the user's .bashrc, .bash_profile, .profile, or equivalent shell startup files.

    Global Startup Scripts:
        To execute tasks for all users when they log in, you can add commands or scripts to global shell startup files like /etc/profile or /etc/bash.bashrc (location may vary depending on the Unix distribution).

    Startup Services (rc.local):
        On some Unix systems, you can add custom commands or scripts to the /etc/rc.local file, which runs at the end of the system's boot process.

    Initramfs Scripts:
        For more advanced startup tasks or customization of the early boot process, you can create custom initramfs scripts. This is typically done by experienced system administrators and requires a good understanding of the boot process.

    Using daemons and Supervisors:
        Some applications may come with their own daemon management scripts or supervisor tools (e.g., supervisord, runit


One .sh file starts from .service that will start the other following .sh files
### app/dashboard
Start-up routine for dashboard
### app/piracer_py
To autostart the piracer_py project when the Ubuntu System boots, we used the following steps:

Create a shell file within the piracer_py folder that will navigate to the project folder, activates the virtual enviorment and starts the run.py file. Additionally, make the .sh executable. 

```bash
#!/bin/bash# Navigate to your project directory 
cd home/dev/DES_Instrument_Cluster/piracer_py
# Activate the virtual environment 
Source venv/bin/activate
# Run your Python project 
sudo python run.py
```

Allowing a specific Python file to be executed with sudo without requiring a password prompt can be achieved by modifying the sudoers configuration. Edit the sudoers configuration by open a terminal and use the visudo command to edit the sudoers file:
```bash
sudo visudo
```    
Add the following line at the end of the sudoers file. 
```bash
username ALL=(ALL) NOPASSWD: /usr/bin/python3 /home/dev/DES02-PiRacer-instrument/app/piracer_py/run.py
``` 
The line specifies that the user can run the run.py file using sudo without being prompted for a password. It uses /usr/bin/python3 as the executable for running the Python script. 

After making the change, save and exit the sudoers files by pressing Ctrl+X, followed by Y, and then Enter.

Next, ensure it's working as intended with the command:
```bash
sudo /usr/bin/python3 /home/dev/DES02-PiRacer-instrument/piracer_py/run.py
``` 
If everything is set up correctly, it should run the script without asking for a password.
Create a new .service file in etc/systemd/systems that will define the service.
```bash	
sudo nano /etc/systemd/system/start-routine-piracer_py.service
``` 
Add the following content to the .service file:
```bash	
[Unit]
Description = Start piracer_py 
[Service]
Type=simple
ExecStart=home/dev/DES02-PiRacer-instrument/app/piracer_py/startup-piracer_py.sh
[Install]
WantedBy=multi-user.target
``` 
Save and close the file.

Run the following commands to enable and start the service:
```bash	
sudo systemctl enable startup-piracer_py.service
sudo systemctl start startup-piracer_py.service
``` 
Now, the .sh script will be executed every time your Ubuntu 22.04 system boots.

☀️ Note: Remember that this method grants password-less access for a specific Python file to a specific user. Use it judiciously and always exercise caution when dealing with privileged operations on your system.
Please ensure that the script you are running does not require any user interaction or access to resources that are not yet available during the boot process. Start-up routine 

### can-modules (speedsensor)
start up routine for arduino file 
