#!/usr/bin/env bash

# check first arg
if [ -z "$1" ]
  then
    echo "Enter workspace as argument"
    exit 1
fi

# check and set workspace
workspace="$1"
shift
[[ "$workspace" != "prod" && "$workspace" != "stage" ]] && echo "workspace available prod or stage" && exit 1

# set default var
action="create"
profile="netology"
folder="netology"
k8s_name="netology"
sa_terraform="sa-terraform"

# set var from arg
while [[ $# -gt 0 ]]; do
  case "$1" in
    '--destroy'|'--delete') action="delete";;
    '--destroy_full'|'--delete_full') action="delete"; action_bucket="delete";;
    '--rekey') rekey="true";;
    '--reinit') reinit="true";;
    '--profile') shift; profile="$1";;
    '--folder') shift; folder="$1";;
  esac
  shift
done

function yandex_init() {

    # first init
    while true
    do
        if ! yc config profile list | grep ^"$profile ACTIVE"$ &> /dev/null && ! yc resource-manager folder get "$folder" | grep "ERROR:" &> /dev/null
        then
            echo -e "create profile and folder \e[41m$profile\e[0m"
            yc init
        else break
        fi
    done

    # check profile
    yc config profile activate "$profile"
    # set folder 4 terraform var
    yc config profile get "$profile" | grep folder | sed 's/: / = \"/' | sed 's/\(.*\)/\1"/g' | tee bucket/terraform.tfvars project/terraform.tfvars

    # check sa and create
    if ! yc iam service-account list | grep "$sa_terraform" &> /dev/null
    then
        yc iam service-account create --name "$sa_terraform"
    fi

    # delete old key in sa
    for line in $(yc iam key list --service-account-name "$sa_terraform" --format yaml | grep "\- id" | cut -c 7-)
    do
        yc iam key delete --id "$line"
    done

    # create key 4 sa
    yc iam key create --service-account-name "$sa_terraform" --output key.json &> /dev/null
    # get id sa
    sa_id=$(yc iam service-account get sa-terraform | grep ^id | cut -c 5-)

    # set role 4 sa
    yc iam service-account set-access-bindings -y "$sa_terraform" \
        --access-binding role=admin,subject=serviceAccount:"${sa_id}" \
        &> /dev/null

    # set role folder 4 sa
    yc resource-manager folder set-access-bindings -y "$folder" \
        --access-binding role=admin,subject=serviceAccount:"${sa_id}" \
        &> /dev/null

}


function yandex_delete() {

    # key delete
    rm -f key.json bucket/terraform.tfvars project/terraform.tfvars

    # check sa and delete
    if yc iam service-account list | grep "$sa_terraform" &> /dev/null
    then
        yc iam service-account delete --name "$sa_terraform"
    fi

    #check folder and delete
    # if yc resource-manager folder list | grep "$folder" &> /dev/null
    # then
    #     yc resource-manager folder delete "$folder"
    # fi
}


function terraform_bucket() {

    cd bucket || exit

    # init tarraform
    terraform init
    # delete project
    [ "$action" == "delete" ] && terraform destroy -auto-approve

    # create project
    [ "$action" == "create" ] && terraform apply -auto-approve

    cd ..
}


function terraform_project() {

    cd project || exit

    # init tarraform
    terraform init -reconfigure

    # check workspace
    workspace_exist=$(terraform workspace list | cut -c 3- | grep ^"$workspace"$) || true

    # create workspace
    [ -z "$workspace_exist" ] && terraform workspace new "$workspace"

    # select workspace
    terraform workspace select "$workspace"

    # delete project
    [ "$action" == "delete" ] && terraform destroy -auto-approve

    # delete workspace
    [ "$action" == "delete" ] && terraform workspace select default && terraform workspace delete "$workspace"

    # create project
    [ "$action" == "create" ] && terraform apply -auto-approve

    cd ..
}

function kube_config() {

    # get config
    [ "$action" == "create" ] && yc managed-kubernetes cluster get-credentials "${k8s_name}-${workspace}" --external --force
}

# main

# yc create profile, service account
[ ! -f "key.json" ] || [ ! -f "bucket/terraform.tfvars" ] || [ ! -f "project/terraform.tfvars" ] || [ "$rekey" == "true" ] && yandex_init

# terraform create bucket, docker registry
[ ! -f "project/version.tf" ] || [ "$reinit" == "true" ] && terraform_bucket

# project create, delete
[ "$action" == "create" ] || [ "$action" == "delete" ] && terraform_project

# delete full
[ "$action_bucket" == "delete" ] && terraform_bucket && yandex_delete

# kube config get, unset
[ "$action" == "create" ] && kube_config


# Failed to create pod sandbox: rpc error: code = Unknown desc = failed to get sandbox image "cr.yandex/crpsjg1coh47p81vh2lc/pause:3.5": failed to pull image "cr.yandex/crpsjg1coh47p81vh2lc/pause:3.5": failed to pull and unpack image "cr.yandex/crpsjg1coh47p81vh2lc/pause:3.5": failed to resolve reference "cr.yandex/crpsjg1coh47p81vh2lc/pause:3.5": failed to do request: Head "https://cr.yandex/v2/crpsjg1coh47p81vh2lc/pause/manifests/3.5": dial tcp 84.201.171.239:443: i/o timeout