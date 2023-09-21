START_CMD='bundle exec puma -C config/puma.rb'
alias start=$START_CMD
alias be='bundle exec'


cat ./infra/docker/scripts/ascii_logo.txt

echo -e "\nWelcome!\n"
echo "- From a bash prompt, use 'start' or '$START_CMD' to run the app."
echo "- It will be available at localhost:4500"

echo ""
