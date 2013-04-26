#!/bin/bash
# created by Zoltan Tarcsay

# ZenDesk credentials
#USERNAME=
#PASSWORD=
ZENDESK_URL="https://forgerock.zendesk.com"

# File names
USERS="users.xml"
ORGS="organizations.xml"

# Output file name
FILE_NAME="list"

# Ask for ZenDesk credentials if they're not set
function readCredentials () {
    if [[ -z "${USERNAME}" ]]; then
        read -p "ZenDesk username: " USERNAME
    fi
    if [[ -z "${PASSWORD}" ]]; then
        read -s -p "ZenDesk password: " PASSWORD
    fi
}

# Get XML from ZenDesk REST API
# Param $1 file name
function getList () {
    echo "Downloading ${1} from Zendesk."
    curl -s -u ${USERNAME}:${PASSWORD} ${ZENDESK_URL}/${1} -O
}

# Combine User and Org list
function combineLists () {
    printf "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<?xml-stylesheet type=\"text/xsl\" href=\"${FILE_NAME}.xsl\"?>\n<root>\n" > ${FILE_NAME}.xml
    sed -n '2,$p' ${USERS} >> ${FILE_NAME}.xml
    sed -n '2,$p' ${ORGS} >> ${FILE_NAME}.xml
    echo "</root>" >> ${FILE_NAME}.xml
}

# Create the XML stylesheet
function createXSL () {
cat > ${FILE_NAME}.xsl << EOF
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
"Name","Email","Creation Date","Org Name",
<xsl:for-each select="root/users/user[organization-id/text() and email/text()]">
<xsl:sort select="organization-id" order="ascending" />
<xsl:variable name="orgId" select="organization-id" />
<xsl:variable name="orgsWithAMSubscr" select="//root/organizations/organization[id=\$orgId and contains(current-tags,'${GROUP}')]" />
<xsl:if test="count(\$orgsWithAMSubscr) &gt; 0">"<xsl:value-of select="name"/>","<xsl:value-of select="email"/>","<xsl:value-of select="created-at"/>","<xsl:value-of select="\$orgsWithAMSubscr/name"/>",
</xsl:if>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
EOF
}

# Generate the formatted output and save it as CSV
function getCSV () {
    # TODO check if dir is writable
    xsltproc ${FILE_NAME}.xml | sed -n '3,$p' > ${FILE_NAME}.csv
    printf "\nDone. The output is at `pwd`/${FILE_NAME}.csv"
}

# Help
function usage () {
    cat << EOF
usage: $0 options

This script converts ZenDesk XML user lists to CSV files.

OPTIONS:
   -u      <username> ZenDesk Username
   -p      <password> ZenDesk password
   -f      <filename> Output file name (an xml, an xsl an a csv file will be created)
   -g      <tag name> Group/tag filter for organizations (e.g. "openam", "partner")
   -d      Download lists from ZenDesk. If not specified, local files are used.
   -h      Help
EOF
}


# Body

while getopts "u:p:f:g:hd" OPTION; do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        u)
            USERNAME=${OPTARG}
            ;;
        p)
            PASSWORD=${OPTARG}
            ;;
        f)
            FILE_NAME=${OPTARG}
            ;;
        g)
            GROUP=${OPTARG}
            ;;
        d)
            readCredentials
            getList ${USERS}
            getList ${ORGS}
            ;;
    esac
done

combineLists
createXSL
getCSV

echo ""
