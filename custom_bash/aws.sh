function aws.login() {
  local profiles profile_name aws_creds

  # Print lines starting with "[profile " or "//", ignoring leading spaces
  echo "FILTERED ~/.AWS/CONFIG CONTENT:"
  grep -E '^\s*\[profile |^[ ]*//' ~/.aws/config

  echo "------------------"
  echo ""
  # Add an additional option to open the URL
  profiles=$(sed -n 's/^\[profile \(.*\)\]/\1/p' ~/.aws/config)
  profiles="$profiles open_console"

  # Prompt the user to select a profile
  echo "SELECT AN AWS PROFILE:"
  select profile_name in $profiles; do
    if [ "$profile_name" == "open_console" ]; then
      open "https://cba-cns.awsapps.com/start"
      return
    elif [ -n "$profile_name" ]; then
      break
    else
      echo "Invalid selection. Please try again."
    fi
  done

  proxy.unset

  export AWS_PROFILE=$profile_name

  # Check if user is already logged in
  aws_creds=$(aws configure export-credentials)
  if [[ $? -ne 0 ]]; then
      # Use the selected profile name to log in
      aws sso login --profile $profile_name
  fi

  # Verify your identity
  aws sts get-caller-identity

  echo "Success. You are logged in with profile $profile_name."
}

#account_id,aws_profile,role,aws_test_function,desc
AWS_PROFILES=(
'123' 'admin_user_role_assume_all-123' 'AdminUserRole' 'aws_test_s3' 'desc')

function aws.cw.kafka.topic() {
  TMP_DATE=$1
  TMP_START=$2
  TMP_END=$3
  TMP_TOPIC=$4
  if [[ -z $TMP_DATE || -z $TMP_START || -z $TMP_END || -z $TMP_TOPIC ]]; then
    echo "1st Param is Date. Ex: 2023-04-13"
    echo "Please give Sydney Start and End time as the next 2 params (AEST) (if 18:00:00 then 18)"
    echo "The last parameter is the topic"
  else
    TMP_METRICS=( BytesInPerSec BytesOutPerSec MessagesInPerSec )
    TMP_CHAR=T
    TMP_START=$((TMP_START - 10))
    TMP_END=$((TMP_END - 10))
    if [[ $TMP_START -lt 10 ]]; then
      TMP_START="0$TMP_START";
    fi
    if [[ $TMP_END -lt 10 ]]; then
      TMP_END="0$TMP_END";
    fi
    for i in "${TMP_METRICS[@]}"
    do
      echo "Opening $i"
      TMP_LINK="https://ap-southeast-2.console.aws.amazon.com/cloudwatch/home?region=ap-southeast-2#metricsV2:graph=~(view~'timeSeries~stacked~false~start~'$TMP_DATE$TMP_CHAR$TMP_START*3a00*3a00.000Z~end~'$TMP_DATE$TMP_CHAR$TMP_END*3a59*3a59.000Z~region~'ap-southeast-2);query=~'*7bAWS*2fKafka*2c*22Broker*20ID*22*2c*22Cluster*20Name*22*2cTopic*7d*20*22Cluster*20Name*22*3deventhub-nft*20Topic*3d$TMP_TOPIC*20MetricName*3d$i'"
      echo $TMP_LINK
      open $TMP_LINK
      read -n1
    done
  fi
  unset TMP_DATE
  unset TMP_START
  unset TMP_END
  unset TMP_TOPIC
  unset TMP_METRICS
  unset TMP_LINK
  unset TMP_CHAR
}

function aws.setup() {
  proxy.me
  pass.aws
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
}

function aws_test_sts_getcalleridentity() {
  echo "Testing Caller Identity - STARTED"
  aws sts get-caller-identity
  echo "Testing Caller Identity - FINISHED"
}

function aws_test_s3() {
  echo "Testing S3 - STARTED"
  aws s3 ls
  echo "Testing S3 - FINISHED"
}


function aws.generate.alias() {
	for i in "${!AWS_PROFILES[@]}"; do 
    if [[ "$(($i%5))" -eq 0 ]]; then
      #account_id,aws_profile,role,aws_test_function,desc
      TMP_AWS_ACCOUNT_ID=${AWS_PROFILES[$i]}
      TMP_AWS_PROFILE=${AWS_PROFILES[$i+1]}
      TMP_AWS_ROLE=${AWS_PROFILES[$i+2]}
      TMP_AWS_TEST_FUNCTION=${AWS_PROFILES[$i+3]}
      TMP_AWS_DESC=${AWS_PROFILES[$i+4]}
      TMP_AWS_NEW_FUNCTION=$(cat <<-END
        function aws.profile.$TMP_AWS_ACCOUNT_ID.$TMP_AWS_DESC() {
          aws.setup;
          export AWS_PROFILE=$TMP_AWS_PROFILE;
          aws sso login;
          TMP_CRE=\$(aws sts assume-role --role-arn "arn:aws:iam::$TMP_AWS_ACCOUNT_ID:role/$TMP_AWS_ROLE" --role-session-name AWSCLI-Session --region ap-southeast-2);
          export AWS_ACCESS_KEY_ID="\$(echo \${TMP_CRE} | jq -r '.Credentials.AccessKeyId')";
          export AWS_SECRET_ACCESS_KEY="\$(echo \${TMP_CRE} | jq -r '.Credentials.SecretAccessKey')";
          export AWS_SESSION_TOKEN="\$(echo \${TMP_CRE} | jq -r '.Credentials.SessionToken')";
          $TMP_AWS_TEST_FUNCTION;
          unset TMP_CRE;}
      )
      eval $TMP_AWS_NEW_FUNCTION
    fi
	done
  unset TMP_AWS_ACCOUNT_ID
  unset TMP_AWS_PROFILE
  unset TMP_AWS_ROLE
  unset TMP_AWS_TEST_FUNCTION
  unset TMP_AWS_DESC
  unset TMP_AWS_NEW_FUNCTION;
}


aws.generate.alias

