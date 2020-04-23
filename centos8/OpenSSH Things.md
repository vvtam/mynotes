Optionally, change the welcome message that your `OpenSSH` server displays before a client authenticates by editing the `/etc/issue` file, for example:

```
Welcome to ssh-server.example.com
Warning: By accessing this server, you agree to the referenced terms and conditions.
```

Note that to change the message displayed after a successful login you have to edit the `/etc/motd` file on the server. See the `pam_motd` man page for more information.