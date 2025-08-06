---
title: Lab Computing
layout: single 
permalink: /posts/compute/
class: resources
toc: true
toc_icon: "link"
toc_sticky: true
---

## Lab Computing Resources
### Access
In order to access ADCL servers, follow the steps below.

1. Download and set up [CU's VPN](https://oit.colorado.edu/services/network-internet-services/vpn) if you haven't already.
2. Connect to CU's network via the VPN.
3. ssh into the server, generally with the following syntax: `<username>@<server_name>.colorado.edu` where `<username>` and `<server_name>` are replaced with your username and the name of the server being accessed.
4. Enter your password and use the commandline interface as you would locally.

To setup remote connections in VS Code, complete the above steps if you haven't already set up remote access and install the [Remote-SSH extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) and follow the steps [here](https://code.visualstudio.com/docs/remote/ssh#_connect-to-a-remote-host). Note the VPN must be connected to use remote access in VSCode.

### Session Management
Use [users](https://linux.die.net/man/1/users) to see a list of currrently logged-in users.

Use [htop](https://linux.die.net/man/1/htop) to keep track of which system resources are being used and by whom. This is especially important to avoid running multiple resource intesive processes at once. If there are current procecsses using many resources, check with the owner before starting additional processes to avoid interfering with each other's processes.

Likewise, before generating or downloading large files, check that there is sufficient space on the machine and move (your) old files to the storage drive as needed to free up space. [ncdu](https://linux.die.net/man/1/ncdu) is a useful utility for seeing file/folder sizes of the current directory. Run this from `/home` or the root directory (`/`) to see additional disk usage information. [df](https://linux.die.net/man/1/df) (specifically `df -h`) is useful for [viewing disk partition use](https://www.geeksforgeeks.org/df-command-linux-examples/).

### Persisent Sessions
[Tmux](https://manpages.ubuntu.com/manpages/xenial/en/man1/tmux.1.html) is useful for keeping remote processes running without requiring an active connection to the server. See [this tutorial](https://linuxize.com/post/getting-started-with-tmux/) for more information. [Julia in VS Code](https://www.julia-vscode.org/docs/stable/userguide/remote/#Remote-Development) has documentation on enabling persistent sessions within VS Code with Tmux. **Please update the `Tmux Session Name` field to include your username to avoid naming conflicts.** See this [forum post](https://discourse.julialang.org/t/how-to-enable-and-use-persistent-remote-connection-with-vscode-tmux/76926/5) for details on how to end a Tmux Julia session in VSCode, as **this is different from the usual terminal behavior**.

### Using Julia
[Juliaup](https://github.com/JuliaLang/juliaup) is a Julia version manager. Installing this in your user folder ensures control over your Julia versions and packages. You may need to edit `~/.profile` to ensure the Juliaup path is at the top of the list if you have issues launching Julia with Juliaup.

### Github
Follow [instructions for SSH setup](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) to enable cloning of private repositories.

### Storage
Please limit main drive usage to **65 GB per user**. The system has a 1.8 TB storage drive which is located at `/media/storage`. The system does not mount the drive automatically, so mounting the drive on restart of the machine may be necessary. It may be mounted using the command `sudo mount /dev/sdb1 /media/storage`. Note that you may need to change directories after mounting the drive for its contents to show. 

Files may be moved with the [`mv` command](https://ubuntu.com/tutorials/command-line-for-beginners#5-moving-and-manipulating-files). Note you may need to use `sudo mv`.

### System Administration
See [ADCL System Administration](https://o365coloradoedu-my.sharepoint.com/:w:/r/personal/bekr4901_colorado_edu/_layouts/15/Doc.aspx?sourcedoc=%7B6DBA0F17-9DE1-4C2B-9E0E-42634F60D570%7D&file=INTERNAL%20-%20ADCL%20System%20Administration.docx&action=default&mobileredirect=true)

## CU Computing Resources
### Alpine
Alpine is a [well documented](https://curc.readthedocs.io/en/latest/clusters/alpine/index.html) CU-wide SLURM cluster. To get started with Julia on Alpine:

* [Make an account](https://rcamp.rc.colorado.edu/accounts/account-request/create/verify/ucb)
* You may need to wait for some time between making an account and logging in for the first time, the documentation says ~15 minutes
* Go to the [OnDemand page](https://ondemand.rc.colorado.edu/)
  * If you get an error, try either clearing your cache/cookies or starting an incognito window
* Request an interactive session
  * Interactive Apps (top of screen) -> Jupyter Session
  * Check "Use JupyterLab"
  * Preset configuration "4 cores, 4 hours"
  * Launch
  * This should take less than a minute to queue and initialize
* Install and configure Julia
  * Click the host link i.e. `>_c3cpu-c15-u34-3.rc.int.colorado.edu`
  * Either save and execute the following bash script, or run line by line. This may take several minutes to run
```
#!/bin/bash
echo export JULIA_DEPOT_PATH=/projects/$USER/.julia >> ~/.bashrc
echo export JULIAUP_DEPOT_PATH=/projects/$USER/.julia >> ~/.bashrc 
source ~/.bashrc
curl -fsSL https://install.julialang.org | sh
source ~/.bashrc
julia --threads auto -e 'import Pkg; Pkg.add("IJulia"); using IJulia; IJulia.installkernel("Julia", "--threads=auto"; env=Dict("JULIA_DEPOT_PATH"=>"/projects/" * ENV["USER"] * "/.julia"))'
```
* Log out from your shell and close the tab
* Back on the OnDemand page "Connect to Jupyter"
* In JupyterLab
  * File -> Open from Path… -> /home/{Username} i.e. /home/jawa5671
  * Create a Julia notebook
  * println("Hello world!")

Note: You may need to re-run the `IJulia.installkernel` function when you install a new version of Julia
