gem update --system
bundle install
rails db:prepare

# VSCode debugger profile.
mkdir -p .vscode && cp .devcontainer/launch.json .vscode/launch.json
