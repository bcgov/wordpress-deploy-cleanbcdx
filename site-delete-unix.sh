#!/usr/bin/env bash
#set -euo pipefail

if [ ! -z "${OC_ENV}" ] && [ ! -z "${OC_SITE_NAME}" ];  then
    echo >&2 "Project:   ${OC_ENV}"
    echo >&2 "Site Name: ${OC_SITE_NAME}"
    echo >&2 "Namespace: ${NAMESPACE}"
    
    whoAmI="$(oc whoami 2> /dev/null)"
    # This means i am logged in.
    if [ ! -z "${whoAmI}" ]; then
    
        printf >&2 "\nStarting Delete Build......with user ${whoAmI}\n"
        echo "Deleting wordpress secrets ${OC_SITE_NAME}-wordpress-secrets"
        oc delete secrets ${OC_SITE_NAME}-wordpress-secrets -n ${NAMESPACE}     
        echo "Applying Kustomize configuration"       
        # Inject namePrefix into kustomization.yaml
        sed -i 's/namePrefix:.*$/namePrefix: '$OC_SITE_NAME'-/' ./deployments/kustomize/overlays/cleanbcdx-${OC_ENV}/kustomization.yaml
        sed -i 's/site:.*$/site: '$OC_SITE_NAME'/' ./deployments/kustomize/overlays/cleanbcdx-${OC_ENV}/kustomization.yaml
        sed -i 's/name: .*-wordpress-nginx/name: '$OC_SITE_NAME'-wordpress-nginx/' ./deployments/kustomize/overlays/cleanbcdx-${OC_ENV}/patch.yaml        
        sed -i 's/host: .*/host: '$OC_SITE_NAME'.apps.gold.devops.gov.bc.ca/' ./deployments/kustomize/overlays/cleanbcdx-${OC_ENV}/patch.yaml
        sed -i 's/APP_DOMAIN=.*$/APP_DOMAIN='$OC_SITE_NAME'.apps.gold.devops.gov.bc.ca/' ./deployments/kustomize/overlays/cleanbcdx-${OC_ENV}/kustomization.yaml
        sed -i 's/WORDPRESS_DB_HOST=.*$/WORDPRESS_DB_HOST='${OC_SITE_NAME}'-wordpress-mariadb/' ./deployments/kustomize/overlays/cleanbcdx-${OC_ENV}/kustomization.yaml
        sed -i 's/secretName: .*$/secretName: '${OC_SITE_NAME}'-wordpress-secrets/' ./deployments/kustomize/overlays/cleanbcdx-${OC_ENV}/patch.yaml
        # Inject namePrefix into patch.yaml
        # sed -i.bak "s|^# *namePrefix:.*$|namePrefix: $OC_SITE_NAME-|g" ./deployments/kustomize/overlays/cleanbcdx-${OC_ENV}/patch.yaml
        oc delete -k ./deployments/kustomize/overlays/cleanbcdx-${OC_ENV}
        # mv -./deployments/kustomize/overlays/cleanbcdx-${OC_ENV}-bak ./deployments/kustomize/overlays/cleanbcdx-${OC_ENV}

    else
        printf >&2 "$(oc whoami)"
    fi
else
    echo >&2 ''
    echo >&2 'Current Variables'
    env | grep -i oc_
    echo >&2 ''
    echo >&2 'Require variables to be set, run: export OC_ENV="test" OC_SITE_NAME="cleanbcdx-bh-test"'
fi
