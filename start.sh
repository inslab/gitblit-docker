#!/bin/bash

if [ ! -f "/opt/gitblit-data/gitblit.properties" ]; then
    cp -rf /tmp/gitblit-data/* /opt/gitblit-data
    if [ -n "$LDAP_HOST" ] && [ -n "$LDAP_PORT" ] && [ -n "$LDAP_BASE_DN" ]
        then
        echo "--> LDAP setting"
        sed -e 's%^realm.authenticationProviders =$%realm.authenticationProviders = ldap%' \
            -e 's%^realm.ldap.server = ldap://localhost%realm.ldap.server = ldap://'"$LDAP_HOST"':'"$LDAP_PORT"'%' \
            -e 's%^realm.ldap.accountBase = OU=Users,OU=UserControl,OU=MyOrganization,DC=MyDomain$%realm.ldap.accountBase = '"$LDAP_BASE_DN"'%' \
            -e 's%^realm.ldap.accountPattern = (&(objectClass=person)(sAMAccountName=${username}))%realm.ldap.accountPattern = (\&(objectClass=person)(uid=${username}))%' \
            -e 's%^realm.ldap.username = cn=Directory Manager$%realm.ldap.username =%' \
            -e 's%^realm.ldap.password = password$%realm.ldap.password =%' \
            /tmp/gitblit-data/gitblit.properties > /opt/gitblit-data/gitblit.properties
    rm -rf /tmp/gitblit-data
    else
        echo "Skipped LDAP setting"
    fi
fi

cd /opt/gitblit
java -server -Djava.awt.headless=true -jar /opt/gitblit/gitblit.jar --baseFolder /opt/gitblit-data
