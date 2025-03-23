#!/usr/bin/env bash

# Authentication and default settings
source "$GITNAP/utils/auth.sh"
source "$GITNAP/utils/endpoints.sh"
source "$GITNAP/utils/settings.sh"
source "$GITNAP/utils/format_pullrequest.sh"


function merge_gitlab_pullrequest() {
    local pr
    local REPO
    local OWNER
    local payload
    local endpoint
    local response
        
    # Pull Request number
    pr="$1"

    # Verifica se o parâmetro foi fornecido
    if [[ -z "$pr" ]]; then
        echo "Pull Request number is required."
        exit 1
    fi
        
    # Name of repository
    REPO="$2"
    
    # Verifica se o parâmetro foi fornecido
    if [[ -z "$REPO" ]]; then
        # Se não foi fornecido, utiliza o nome do diretório atual
        REPO=$(basename "$PWD")
    fi

    # Repo owner
    OWNER="$3"
    
    # Verifica se o parâmetro foi fornecido
    if [[ -z "$OWNER" ]]; then
        # Se não foi fornecido, utiliza o padrão definido em auth.sh
        OWNER="$DEF_GH_OWNER"
    fi
        
    # Create the JSON payload for the repository
    payload='{"merge_method":"squash"}'

    # Construct the endpoint URL
    pr_endpoint="$(build_gl_endpoint "PR" "$OWNER" "$REPO")"
    endpoint="$pr_endpoint/$pr/merge"
    
    # Create the repository using curl
    response=$(curl -sSL -X PUT "$endpoint" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $GITLAB_TOKEN" \
        -d "$payload" )

    # Check if there are erros
    echo "$response" #| jq -r '.number // .message'
}

merge_gitlab_pullrequest "$1" "$2" "$3"
