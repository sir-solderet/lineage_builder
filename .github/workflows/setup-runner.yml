#Needs to be run once only!
name: Needs to be run once only! Running again leads to reset

on:
  workflow_dispatch:
    inputs:
        GITHUB_REPO:
            description: 'Repository url'
            default: 'https://github.dev/a57y17lte-dev/lineage_builder'
            required: true
        RUNNER_TOKEN:
            description: 'This is the runner token, not PAT'
            required: true
        
jobs:
  run-devspace-and-tmux:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Set up environment
      run: |
        sudo apt-get update
        sudo apt-get install -y tmux
      # Download and configure 'crave'.
    - name: Configure the 'crave' environment
      run: |
        if [ "${DCDEVSPACE}" == "1" ]; then
        echo 'No need to set up crave, we are already running in devspace!'
        else
          mkdir ${HOME}/bin/
          curl -s https://raw.githubusercontent.com/accupara/crave/master/get_crave.sh | bash -s --
          mv ${PWD}/crave ${HOME}/bin/
          sudo ln -sf /home/${USER}/bin/crave /usr/bin/crave
          envsubst < ${PWD}/crave.conf.sample >> ${PWD}/crave.conf
          rm -rf ${PWD}/crave.conf.sample          
        fi
      env:
        CRAVE_USERNAME: ${{  secrets.CRAVE_USERNAME  }}
        CRAVE_TOKEN: ${{  secrets.CRAVE_TOKEN  }}

    - name: Run crave devspace
      run: |
        crave devspace -- "rm -rf y17ltebuilds actions-runner || true
        curl https://raw.githubusercontent.com/sounddrill31/Install-GithubActions-Runner/main/fetch-latest-zip.sh | bash
        mv actions-runner y17ltebuilds
        cd y17ltebuilds
        if [[ ${{ inputs.RUNNER_TOKEN }} == github_pat_* ]]; then
            # Generate a new runner token
            export RUNNER_TOKEN=$(curl -sS -H "Authorization: token ${{ inputs.RUNNER_TOKEN }}" https://api.github.com/runners/registration-token | jq -r '.token')
            echo "PAT found! Runner token generated"
        else
            echo "Runner token found"
            export RUNNER_TOKEN=${{ inputs.RUNNER_TOKEN }}

        fi
         ./config.sh --url ${{ inputs.GITHUB_REPO }} --token ${RUNNER_TOKEN} --agent y17ltebuilds --work work --unattended
         echo "Done setting up!""