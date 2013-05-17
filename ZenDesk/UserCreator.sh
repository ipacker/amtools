#!/bin/bash

# Zendesk URL - forgerock1367225012.zendesk.com is the sandbox
ZD_API_URL="https://support.example.com/api/v2"

ZD_EMAIL_DEFAULT=""

# add -s to CURL if requesting silent
CURL_PREFIX="curl -s"

# See if there's a user CSV file specified, otherwise print help and exit

function usage () {
        cat <<EOF
usage: $0 options

This script imports Resolve user lists into Zendesk.

OPTIONS:
   -i      <input file> CSV file containing user infromation
   -t      test mode (only print cURL commands)
   -d      set the default domain for orgs (if org doesn't exist yet) based on email address
   -h      Help
EOF
}

# Read Zendesk credentials

function read_zd_email () {
    if [[ ! -z "$ZD_EMAIL_DEFAULT" ]]; then
        ZD_EMAIL=[$ZD_EMAIL_DEFAULT]
    fi

    read -p "Zendesk email: ${ZD_EMAIL} " ZD_EMAIL_IN

    if [[ ! -z "$ZD_EMAIL_DEFAULT" && -z "$ZD_EMAIL_IN"  ]]; then
        ZD_EMAIL=$ZD_EMAIL_DEFAULT
    else
        ZD_EMAIL=$ZD_EMAIL_IN
        if [[ -z "$ZD_EMAIL" ]]; then
            read_zd_email
        fi

    fi
}

function read_auth_method () {
    read -p "Please specify auth method: password (1) or API token (2): " AUTH_METHOD

    case $AUTH_METHOD in
    "1")
        read -s -p "Zendesk password: " ZD_PASSWORD
        CURL_PREFIX="${CURL_PREFIX} -u ${ZD_EMAIL}:${ZD_PASSWORD}"
        ;;
    "2")
        read -s -p "Zendesk token: " ZD_TOKEN
        CURL_PREFIX="${CURL_PREFIX} -u ${ZD_EMAIL}/token:${ZD_TOKEN}"
        ;;
    *)
        read_auth_method
        ;;
esac
}

function run_import () {

    # Iterate through the CSV file (ignore lines beginning with #)
    tr '\r' '\n' < "$USERS_CSV_FILE" | grep -v "^\#.*$" | grep "^.*$" | while read line; do

        USER_NAME=$(echo $line | awk 'BEGIN{FS=","}{print $1}')
        USER_EMAIL=$(echo $line | awk 'BEGIN{FS=","}{print $2}')
        ORG_NAME=$(echo $line | awk 'BEGIN{FS=","}{print $5}')

        if [ "$SET_DEFAULT_DOMAIN" == "true" ]; then
            ORG_DOMAIN=${USER_EMAIL/*@/}
        fi
        printf "\nProcessing entry: $USER_NAME - $USER_EMAIL - $ORG_NAME - $ORG_DOMAIN\n"

        # Attempt to create Organization
        printf "\nAttempting to create Organization: $ORG_NAME \n"
        DATA="{\"organization\": {\"name\": \"$ORG_NAME\", \"domain_names\": \"$ORG_DOMAIN\", \"tags\":[\"zz-resolve\"]}}"
        if [ "$TEST_MODE" == "true" ]; then
            printf "$CURL_PREFIX -H \"Content-Type: application/json\" -X POST -d $DATA $ZD_API_URL/organizations.json\n"
        else
            $CURL_PREFIX -H "Content-Type: application/json" -X POST -d "$DATA" "$ZD_API_URL"/organizations.json
        fi

        # Get the existing Org's id
        printf "\nRetrieving ID of Organization: $ORG_NAME... "
        DATA="name=${ORG_NAME//\"/}"
        if [ "$TEST_MODE" == "true" ]; then
            printf "\n$CURL_PREFIX -X POST -d $DATA $ZD_API_URL/organizations/autocomplete.json\n"
            ORG_ID="1234"
        else
            ORG_ID=$($CURL_PREFIX -X POST -d "$DATA" "$ZD_API_URL"/organizations/autocomplete.json)
            ORG_ID=$(echo $ORG_ID | awk 'BEGIN{FS=","}{print $2}')
            ORG_ID=$(echo $ORG_ID | awk 'BEGIN{FS=":"}{print $2}')
        fi
        printf "Org ID is: $ORG_ID\n"

        # Attempt to create User
        printf "\nAttempting to create User: $USER_EMAIL\n"
        DATA="{\"user\": {\"name\": \"$USER_NAME\", \"email\": \"$USER_EMAIL\", \"organization_id\":$ORG_ID, \"tags\":[\"zz-resolve\"]}}"
        if [ "$TEST_MODE" == "true" ]; then
            printf "$CURL_PREFIX -H \"Content-Type: application/json\" -X POST -d $DATA $ZD_API_URL/users.json\n"
        else
            $CURL_PREFIX -H "Content-Type: application/json" -X POST -d "$DATA" "$ZD_API_URL"/users.json
        fi

        printf "\n\n=================================================\n"

    done

}

while getopts "i:hdt" OPTION; do
    case $OPTION in
        h)
            usage
            exit 0
            ;;
        d)
            SET_DEFAULT_DOMAIN="true"
            ;;
        t)
            TEST_MODE="true"
            ;;
        i)
            USERS_CSV_FILE=${OPTARG}
            ;;
    esac
done

if [[ -z "$USERS_CSV_FILE" ]]; then
    usage
    exit 1
fi

read_zd_email
read_auth_method
run_import

exit 0
