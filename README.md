![shellcsrgen](https://github.com/EarlyOwl/ShellCSRGen/assets/49495410/95770e78-95ad-43b5-bd27-634d998f01db)
Generate a CSR+Key from the shell with a GUI

## Contents
- [What is this?](#what-is-this)
- [How does it work?](#how-does-it-work)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [How do I install Dialog?](how-do-i-install-dialog)
- [Misc](#misc)

## What is this?
This script allows you to generate a CSR (and the relative key) with Openssl with ease, providing you with a GUI to input all the necessary parameters (CN, SANs, key length, ecc.)

## How does it work?
The generation is performed by **openssl**, while the graphical interface is rendered via **dialog**. At the end the script produces a .CSR, to be used with your Certification Authority to generate a certificate, and .KEY file containing the private key.

## Prerequisites
- You will need the **openssl** toolkit, in most cases it is installed by default on all Linux distributions ([openssl GitHub page](https://github.com/openssl/openssl#download)).
- The graphical interface is provided by Dialog, so you will need to [install it](#how-do-i-install-dialog) to make this script work.

## Installation

1. Make sure Dialog is available on your system by running:
```
dialog --version
```
If not, you can install it by following the instructions in [this chapter](#how-do-i-install-dialog)

2. Make sure openssl is available on your system by running:
```
openssl version
```

3. Download shellcsrgen.sh from the main branch to your local machine:
```
wget https://raw.githubusercontent.com/EarlyOwl/ShellCSRGen/main/shellcsrgen.sh
```
4. Make it executable:
```
chmod +x shellcsrgen.sh
```

5. Run the script with:
```
./shellcsrgen.sh
```

## Usage
The procedure is pretty straightforward. At first you will have to provide the **Country (C)**, **State (S)**, **Locality (L)**, **Organization Name (O)**, **Organizational Unit (OU)** and, most importantly, the **Common Name (CN)**:
![Screenshot 2023-10-02 194134](https://github.com/EarlyOwl/ShellCSRGen/assets/49495410/2c1592b1-7c3e-4386-881e-33d49cfd26c2)

A prompt will ask you if you want to provide **Subject Alternative Names (SAN)**. If you want to do so, select **Yes**. You will then be able to insert as many **IP/DNS** SANs as you want.
![Screenshot 2023-10-02 200121](https://github.com/EarlyOwl/ShellCSRGen/assets/49495410/43c67d46-be44-4747-b8a7-076fab285244)
![Screenshot 2023-10-02 194153](https://github.com/EarlyOwl/ShellCSRGen/assets/49495410/a9a90a79-e4f2-40ac-bbc4-3fd14d90634f)

The next selection will give 4 options for the key length: **2048**, **3072**, **4096** and **7168**
![Screenshot 2023-10-02 194206](https://github.com/EarlyOwl/ShellCSRGen/assets/49495410/60f0d3b7-2253-4a49-902e-d335c72a8e55)

A confirmation screen will show a brief summary of the provided data. If everything's correct, select **Yes** to proceed.
![Screenshot 2023-10-02 194213](https://github.com/EarlyOwl/ShellCSRGen/assets/49495410/2f04feb1-0378-4786-bd75-825148d745dc)

Finally you will be able to choose the filename/path for both the CSR and the KEY. At the end a confirmation screen will inform you of the successful creation of the files.
![Screenshot 2023-10-02 194219](https://github.com/EarlyOwl/ShellCSRGen/assets/49495410/ab950a33-8dbc-4f8d-94b6-cf9497735f61)
![Screenshot 2023-10-02 194229](https://github.com/EarlyOwl/ShellCSRGen/assets/49495410/34bca16f-7de0-481e-a369-d2780da5b2fe)

## How do I install Dialog?
If Dialog is not present on your machine, you can run those commands based on your current OS / distro to install it:

###### Ubuntu / Debian
```
sudo apt-get update
sudo apt-get install dialog
```

###### RHEL / CentOS
```
sudo yum install dialog
```

###### MacOS
Install it via [HomeBrew](https://docs.brew.sh/Installation) by running:
```
brew install dialog
```

## Misc

##### Can I contribute? Can I reuse all/part of this script for other purposes?
Yes and yes.

##### This sucks / You could have done X instead of X!
I'm eager to learn, open an issue or a  pull request to suggest an improvement / fix.
