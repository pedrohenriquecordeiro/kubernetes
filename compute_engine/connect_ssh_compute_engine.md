# Use VSCode and Remote SSH extension for Google Cloud | Medium
Get more productive with file management on a remote server using VSCode and Remote SSH extension
-------------------------------------------------------------------------------------------------

[

![Ivan Zhdanov](https://miro.medium.com/v2/resize:fill:88:88/1*ddJcBj9vYGjvm1jSpJhdpA.jpeg)









](https://medium.com/@ivanzhd?source=post_page-----9312797d56eb--------------------------------)

*   [Introduction](#6733)
*   [Install Google Cloud SDK](#8e9a)
*   [Generate SSH keys](#3eca)
*   [Create config file](#3bf0)
*   [Install Remote SSH extension and Add new SSH host](#1e71)
*   [Connect to host](#b9e5)
*   [Links](#2749)

SFTP connection to Compute Engine on Google Cloud Platform is convenient for managing files. For sure, you could log in directly to the remote server and do most of the files and folders management via the console with [shell commands](https://help.ubuntu.com/community/UsingTheTerminal) like `cd; ls; pwd;` But it is way more productive to view the folder structure like in any file explorer.

There are multiple SFTP clients available for this purpose. Here are two, which I find best depending on the platform you work:

1.  [Filezilla](https://filezilla-project.org/) for all platforms (free)
2.  [Transmit 5](https://panic.com/transmit/) for macOS (paid)

However, the most satisfying SSH experience is the usage of the [Remote-SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension for the [VSCode](https://code.visualstudio.com/). It gives access to the remote files directly in the developer environment and feels that you work locally.

Here is an official [step-by-step tutorial](https://code.visualstudio.com/docs/remote/ssh-tutorial) to get started with VSCode and Remote-SSH. Below I summarize the steps required to connect to Compute Engine on the Google Cloud platform:

Once you work with Google Cloud Platform, it is wise to install gcloud SDK to execute numerous remote commands from your local console. To do this, [download the SDK](https://cloud.google.com/sdk/docs/install) for your platform to any folder and follow the installation instructions mentioned on the download page. Also, don’t forget to perform the shell commands as discussed there:

```
./google-cloud-sdk/install.sh #To install the gcloud SDK
./google-cloud-sdk/bin/gcloud init # To initialize the gcloud SDK
```


Generate SSH key using the gcloud commands following the [complete instruction](https://cloud.google.com/compute/docs/instances/connecting-to-instance). The `gcloud compute ssh` command is used to generate SSH keys for the first connection. Afterwards, this command connects to the server.

By default, `gcloud` expects keys to be located at the following paths:

*   `$HOME/.ssh/google_compute_engine` – private key
*   `$HOME/.ssh/google_compute_engine.pub` – public key

The content of the configuration file `$HOME/.ssh/config` might be as in the example below, where `XX.XX.XX.XXX` is the External IP Address of your Compute Engine instance.

```
Host XX.XX.XX.XXXHostName XX.XX.XX.XXX
   UseKeychain yes
   AddKeysToAgent yes
   IdentityFile ~/.ssh/google_compute_engine
   User your_username
```


Find Remote SSH extension in the VSCode extensions tab and install it.

Open VSCode and press `⌘ + Shift + P` for macOS or `Ctrl + Shift + P` for Windows to open [VSCode Command Palette](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette). Type in `Remote-SSH` and select `Add New SSH Host…`

Type in your username and External IP Address of your Compute Engine instance like `your_username@XXX.XXX.XXX.XXX`Which you can find in the Google Cloud Platform following the instruction [here](https://cloud.google.com/compute/docs/instances/view-ip-address#console).

Select the SSH configuration file or create a new one.

Go to the VSCode Command Palette again and select `Remote-SSH: Connect to Host…` . It will launch a new VSCode window with the SSH connection like in the [original instruction](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh). Now, you will connect to any folder on your remote server as it was a local folder. This makes the work extremely productive.

Enjoy!
