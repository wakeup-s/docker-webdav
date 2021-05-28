#!/bin/bash
# Manage realms users from the remote machine

# Set ssh access info
sshAccess="<USER>@<HOST>"
# Set project path on the server
authFilePath="<PROJECT_FULL_PATH>/data/httpd/user.passwd"

# Function to get user input for the realm name
askWhatRealm () {

  local PS3='Please choose target realm: '
  local options=("Common" "Secure" "Critical" "Quit")

  select opt in "${options[@]}"
  do
      case $opt in
          Common|Secure|Critical)
              echo "$opt"
              break
              ;;
          Quit)
              exit 0
              break
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}

markGreen () {
  local GREEN='\033[0;32m'
  local NC='\033[0m'
  printf $GREEN$1$NC
}

PS3="What do you want to do: "
options=("Create/update user" "Delete user in realm" "Delete user entirely" "Check user realms or realm users" "Quit")
select opt in "${options[@]}"
do
    case $REPLY in
        "1")
            realm="$(askWhatRealm)"
            printf "Enter user login you want to add or update in the %s realm: " "$(markGreen "$realm")"
            read -r userLogin
            printf "Connecting to %s to set user %s in %s realm...\n" \
             "$(markGreen "$sshAccess")" \
             "$(markGreen "$userLogin")" \
             "$(markGreen "$realm")"

             ssh -t $sshAccess htdigest $authFilePath "$realm" "$userLogin"

            # case has no break for the asking a new command launch
            ;;

        "2")
            realm="$(askWhatRealm)"
            printf "Enter user login you want to delete in the %s realm: " "$(markGreen "$realm")"
            read -r userLogin

            printf "Deleting user %s in %s realm...\n\n" "$(markGreen "$userLogin")" "$(markGreen "$realm")"
            ssh $sshAccess sed -i -e "/^$userLogin:$realm:/d" $authFilePath

            # case has no break for the asking a new command launch
            ;;

        "3")
            printf "Enter user login you want to close access: "
            read -r userLogin

            printf "Deleting user %s in all realms...\n\n" "$(markGreen "$userLogin")"
            ssh $sshAccess sed -i -e "/^$userLogin:/d" $authFilePath

            # case has no break for the asking a new command launch
            ;;

        "4")
            realm="$(askWhatRealm)"

            printf "\nListing users in %s realm:\n" "$(markGreen "$realm")"
            result=$( ssh $sshAccess grep -F :"$realm": "$authFilePath" )

            echo "$result" | grep -oP "^[^:]*(?=:$realm:)"
            printf "\n"

            # case has no break for the asking a new command launch
            ;;

        "5")
            exit 0
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
