#!/bin/bash

#Github: EarlyOwl/ShellCSRGen
#ver 1.0.1 -- This script is licensed under the MIT License

# Function to display an error message
show_error() {
    dialog --backtitle "CSR Generation" --title "Error" --msgbox "$1" 8 40
}

# Function to display a confirmation message
show_confirmation() {
    dialog --backtitle "CSR Generation" --title "Confirmation" --msgbox "$1" 8 40
}

# Function to display a prompt for additional SANs
prompt_additional_sans() {
    dialog --backtitle "CSR Generation" --title "Additional SANs" --yesno "Do you want to provide additional SANs?" 8 40
}

# Function to display a prompt for DNS name or IP address
prompt_sans_type() {
    dialog --backtitle "CSR Generation" --title "Additional SANs" --menu "Select the type of SAN you want to provide:" 12 40 5 1 "DNS Name" 2 "IP Address" 2>&1 >/dev/tty
}

# Function to display a textbox for SAN input
prompt_sans_input() {
    local sans_type=$1
    dialog --backtitle "CSR Generation" --title "Additional SANs" --inputbox "Enter the $sans_type:" 8 40 2>&1 >/dev/tty
}

# Function to display a prompt for the desired key length
prompt_key_length() {
    dialog --backtitle "CSR Generation" --title "Key Length" --menu "Select the desired key length:" 12 40 5 1 "2048" 2 "3072" 3 "4096" 4 "7168" 2>&1 >/dev/tty
}

# Function to display a recap of user inputs for confirmation
show_recap() {
    local dn=$1
    local cn=$2
    local sans=$3
    local key_length=$4
    dialog --backtitle "CSR Generation" --title "Confirmation" --yesno "Please review the information:\n\nDN: $dn\nCommon Name: $cn\nSANs: $sans\nKey Length: $key_length\n\nIs the information correct?" 14 60
}

# Function to display a prompt for the CSR file location
prompt_csr_output() {
    local default_path="$PWD/$common_name.csr"
    dialog --backtitle "CSR Generation" --title "CSR Output" --inputbox "Enter the CSR file location:" 8 60 "$default_path" 2>&1 >/dev/tty
}

# Function to display a prompt for the key file location
prompt_key_output() {
    local default_path="$PWD/$common_name.key"
    dialog --backtitle "CSR Generation" --title "Key Output" --inputbox "Enter the key file location:" 8 60 "$default_path" 2>&1 >/dev/tty
}

# Function to display a visual confirmation of the created key
show_completion() {
    local csr_file=$1
    local key_file=$2
    dialog --backtitle "CSR Generation" --title "Key Creation Complete" --msgbox "CSR and Key files have been created:\n\nCSR file: $csr_file\nKey file: $key_file" 10 60
}

# Main script logic

# Prompt for user information
dialog_data=$(dialog --backtitle "CSR Generation" --title "User Information" --form "Enter your information:" 16 60 8 \
    "Country (2 characters):" 1 1 "" 1 30 2 2 \
    "State (64 characters):" 2 1 "" 2 30 64 0 \
    "Locality (64 characters):" 3 1 "" 3 30 64 0 \
    "Organization (64 characters):" 4 1 "" 4 30 64 0 \
    "Organizational unit (64 characters):" 5 1 "" 5 30 64 0 \
    "Common Name (64 characters):" 6 1 "" 6 30 64 0 \
    2>&1 >/dev/tty)

# Check if 'Cancel' was pressed or Esc was pressed
if [ "$?" != 0 ]; then
    exit
fi

# Parse user information
IFS=$'\n'
user_info=($dialog_data)
C="${user_info[0]}"
ST="${user_info[1]}"
L="${user_info[2]}"
O="${user_info[3]}"
OU="${user_info[4]}"
common_name="${user_info[5]}"
IFS=' '

# Initialize SAN array
sans_array=()

# Prompt for additional SANs
while true; do
    prompt_additional_sans
    case $? in
        0)
            # User selected 'YES' for additional SANs
            sans_type=$(prompt_sans_type)
            case $sans_type in
                1)
                    sans_input=$(prompt_sans_input "DNS Name")
                    if [ -n "$sans_input" ]; then
                        sans_array+=("DNS:$sans_input")
                    fi
                    ;;
                2)
                    sans_input=$(prompt_sans_input "IP Address")
                    if [ -n "$sans_input" ]; then
                        sans_array+=("IP:$sans_input")
                    fi
                    ;;
            esac
            ;;
        1)
            # User selected 'NO' for additional SANs
            break
            ;;
        255)
            # Esc or 'Cancel' was pressed
            exit
            ;;
    esac
done

# Prompt for the desired key length
key_length_choice=$(prompt_key_length)

# Map the key length choice to the actual key length value
case $key_length_choice in
    1) key_length=2048 ;;
    2) key_length=3072 ;;
    3) key_length=4096 ;;
    4) key_length=7168 ;;
    *) show_error "Invalid key length choice." && exit ;;
esac

# Prompt for confirmation of user inputs
show_recap "$C/$ST/$L/$O/$OU" "$common_name" "${sans_array[*]}" "$key_length"
if [ "$?" != 0 ]; then
    exit
fi

# Prompt for the CSR file location
csr_output_filename=$(prompt_csr_output)

# Prompt for the key file location
key_output_filename=$(prompt_key_output)

# Generate the CSR using openssl
if [ ${#sans_array[@]} -gt 0 ]; then
    openssl req -new -nodes -newkey rsa:"$key_length" -keyout "$key_output_filename" -out "$csr_output_filename" \
        -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$common_name" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "\n[SAN]\nsubjectAltName=%s" "${sans_array[*]}"))
else
    openssl req -new -nodes -newkey rsa:"$key_length" -keyout "$key_output_filename" -out "$csr_output_filename" \
        -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$common_name"
fi

# Check if the CSR and key files were created
if [ $? -eq 0 ]; then
    show_completion "$csr_output_filename" "$key_output_filename"
else
    show_error "An error occurred while creating the CSR."
fi
