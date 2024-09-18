#!/bin/bash
# shellcheck disable=SC2155

terraform_init_with_backend()
{
   state_bucket=$1
   terraform init -backend=true -backend-config="region=${aws_region}" -backend-config="bucket=${state_bucket}" -backend-config "key=${env}-${app}.tfstate" -reconfigure
   if [[ "$(terraform workspace list | grep -c "${env}" )" == 0 ]]; then
      terraform workspace new "${env}"
   else
      terraform workspace select "${env}"
      echo "switched to workspace ${env}"
   fi
}

main(){
    echo $@
    action=$1
    env_vars="infra/env-vars/${2}.json"
    echo "Building environment : ${2}"

    export env=${2}
    export app=${3}
    export aws_actid=$(cat "${env_vars}" | jq -r '.aws_account')
    export aws_region=$(cat "${env_vars}" | jq -r '.aws_region')
    export aws_role=$(cat "${env_vars}" | jq -r '.aws_role')
    state_bucket=$(cat "${env_vars}" | jq -r '.state_bucket_name')

    source infra/scripts/aws_helper.sh
    if [ "${assume_role}" == false ]; then
      echo "No switch role enabled"
    else
      aws-switch-to-build-role 
    fi

    case ${action} in

    "component-plan")
        
          cd infra/resources/${app} || exit;
          terraform get
          terraform_init_with_backend "${state_bucket}"
          terraform plan --var-file="../../env-vars/${env}.json" -out="${env}-${component}.plan";
          if [[ $? -ne 0 ]]; then
            exit 1
          fi
          cd ../../../;;  

    "component-build")
          cd infra/resources/${app} || exit;
          terraform get
          terraform_init_with_backend "${state_bucket}"
          terraform apply -auto-approve "${env}-${component}.plan";
          if [[ $? -ne 0 ]]; then
            exit 1
          fi
          rm "${env}-${component}.plan"
          cd ../../../../;;

    "component-destroy")
          cd infra/resources/${app} || exit;
          terraform get
          terraform_init_with_backend "${state_bucket}"
          terraform destroy -auto-approve --var-file="../../env-vars/${env}.json";
          cd ../../../../;;


      "*")
            echo "Invalid input. Please check your command.";;

    esac
    
    if [ "${assume_role}" == false ]; then
      echo "No switch role enabled"
    else
      aws-switch-to-build-role 
    fi
}

main "$@"
