# to make new/fix ssh keys

#Create a 4-line stanza in $HOME/.ssh/config with the following information:
    Host AHDC
    User hcm59
    ForwardAgent yes
    Hostname cbsuahdc01.tc.cornell.edu

# and also this:

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519

#on local machine, create key pair (use default name & non-myid password):
    ssh-keygen -t rsa -f ~/.ssh/id_rsa

copy public key to cluster:
    cat ~/.ssh/id_rsa.pub | ssh AHDC "cat >>  ~/.ssh/
    authorized_keys"

#After a restart on your laptop, if SSH is asking for the password for your private key, type:
  ssh-add $HOME/.ssh/id_rsa


# If Github is having issues, can remake those too
ssh-keygen -t rsa -f ~/.ssh/github_rsa

#Then copy the public key to Github using the “New SSH Key” function at https://github.com/settings/keys
#You can test your GitHub SSH keys are working from your laptop/desktop by typing the following command in a terminal:
ssh -T git@github.com
