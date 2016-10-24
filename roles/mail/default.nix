{ config, pkgs, mailUserPass ? "", ... }:

let
  initialScript = ''
    CREATE MAILSERVER;
    GRANT SELECT ON mailserver.* TO 'mailuser'@'127.0.0.1' IDENTIFIED BY '${mailUserPass}';
    FLUSH PRIVILEGES;

    CREATE TABLE `virtual_domains` (
      `id` int(11) NOT NULL auto_increment,
      `name` varchar(50) NOT NULL,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

    CREATE TABLE `virtual_users` (
      `id` int(11) NOT NULL auto_increment,
      `domain_id` int(11) NOT NULL,
      `password` varchar(106) NOT NULL,
      `email` varchar(100) NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `email` (`email`),
      FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

    CREATE TABLE `virtual_aliases` (
      `id` int(11) NOT NULL auto_increment,
      `domain_id` int(11) NOT NULL,
      `source` varchar(100) NOT NULL,
      `destination` varchar(100) NOT NULL,
      PRIMARY KEY (`id`),
      FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
  '';

  dovecotSqlConf = builtins.toFile "auth-sql.conf.ext" ''
    driver = mysql
    connect = host=10.99.0.2 dbname=mailserver user=mailuser password=${mailUserPass}
    default_pass_scheme = SHA512-CRYPT
    password_query = SELECT email as user, password FROM virtual_users WHERE email='%u';
  '';

  virtualMailboxDomains = builtins.toFile "virtual-mailbox-domains.cf" ''
    user = mailuser
    password = ${mailUserPass}
    hosts = 10.99.0.2
    dbname = mailserver
    query = SELECT 1 FROM virtual_domains WHERE name='%s'
  '';

  virtualMailboxMaps = builtins.toFile "virtual-mailbox-maps.cf" ''
    user = mailuser
    password = ${mailUserPass}
    hosts = 10.99.0.2
    dbname = mailserver
    query = SELECT 1 FROM virtual_users WHERE email='%s'
  '';

  virtualAliasMaps = builtins.toFile "virtual-alias-maps.cf" ''
    user = mailuser
    password = ${mailUserPass}
    hosts = 10.99.0.2
    dbname = mailserver
    query = SELECT destination FROM virtual_aliases WHERE source='%s' UNION ALL SELECT destination FROM virtual_aliases WHERE INSTR('%d', source) AND NOT EXISTS (SELECT destination FROM virtual_aliases WHERE source='%s')
    '';

  virtualEmail2Email = builtins.toFile "virtual-email2email.cf" ''
    user = mailuser
    password = ${mailUserPass}
    hosts = 10.99.0.2
    dbname = mailserver
    query = SELECT email FROM virtual_users WHERE email='%s'
  '';

  noSpamSieve = builtins.toFile "no-spam.sieve" ''
    require "fileinto";
    require "imap4flags";

    if header :is "X-Spam" "yes" {
      fileinto "Junk";
      setflag "\\seen";
      stop;
    }
  '';

in
{
  users.extraUsers.vmail = {
    isNormalUser = false;
    uid = 5000;
    home = "/var/mail";
    extraGroups = [ "vmail" ];
  };

  users.extraGroups.vmail.gid = 5000;

  # Enable redis for use by Rmilter and Rspamd
  services.redis.enable = true;

  services.rspamd.enable = true;

  services.rmilter = {
    enable = true;
    rspamd.enable = true;
    postfix.enable = true;
    extraConfig = ''
      # Enable DKIM signing of outgoing email
      dkim {
        domain {
          key = /etc/rmilter/dkim;
          domain = "*";
          selector = "mail1";
        };
        header_canon = relaxed;
        body_canon = relaxed;
        sign_alg = sha256;
      };

      # Whitelist replies to outgoing messages
      redis {
        servers_id = localhost;
        id_prefix = "message_id.";
      };
    '';
  };

  services.opendkim = rec {
    enable = true;
    keyFile = "/etc/opendkim/mail1.private";
    selector = "mail1";
    configFile = builtins.toFile "opendkim.conf" ''
      Canonicalization relaxed/simple
      SubDomains true
    '';
  };

  services.dovecot2 = {
    enable = true;
    enablePop3 = false;
    enableLmtp = true;
    enablePAM = false;
    mailGroup = "vmail";
    mailUser = "vmail";
    mailLocation = "maildir:/var/mail/vhosts/%d/%n";
    modules = with pkgs; [ dovecot_antispam dovecot_pigeonhole ];
    sslCACert = "/etc/letsencrypt/live/mail.server.geek.nz/chain.pem";
    sslServerCert = "/etc/letsencrypt/live/mail.server.geek.nz/cert.pem";
    sslServerKey = "/etc/letsencrypt/live/mail.server.geek.nz/privkey.pem";
    sieveScripts = {
      before = noSpamSieve;
    };
    extraConfig = ''
      mail_privileged_group = vmail

      namespace inbox {
        inbox = yes
        mailbox Trash {
          auto = no
          special_use = \Trash
        }
        mailbox Drafts {
          auto = no
          special_use = \Drafts
        }
        mailbox Sent {
          auto = no
          special_use = \Sent
        }
        mailbox Junk {
          auto = create
          special_use = \Junk
        }
      }

      protocol imap {
        mail_plugins = $mail_plugins antispam
      }

      plugin {
        antispam_backend = mailtrain
        antispam_spam = Junk
        antispam_trash = Trash
        antispam_mail_sendmail = ${pkgs.rspamd}/bin/rspamc
        antispam_mail_spam = learn_spam
        antispam_mail_notspam = learn_ham
        antispam_mail_sendmail_args = -h;localhost:11334;-P;q1
      }

      protocol lmtp {
        mail_plugins = $mail_plugins sieve
      }

      service auth {
        unix_listener /var/lib/postfix/queue/private/auth {
          user = postfix
          group = postfix
          mode = 0660
        }

        unix_listener auth-userdb {
          mode = 0600
          user = vmail
        }

        user = dovecot2
      }

      service auth-worker {
        user = vmail
      }

      passdb {
        driver = sql
        args = ${dovecotSqlConf}
      }

      userdb {
        driver = static
        args = uid=vmail gid=vmail home=/var/mail/vhosts/%d/%n
      }

      service imap-login {
        inet_listener imap {
          port = 0
        }

        inet_listener imaps {
          port = 993
          ssl = yes
        }
      }

      service lmtp {
        unix_listener /var/lib/postfix/queue/private/dovecot-lmtp {
          mode = 0600
          user = postfix
          group = postfix
        }
      }
    '';
  };

  services.postfix = rec {
    enable = true;
    domain = "server.geek.nz";
    hostname = "mail.${domain}";
    origin = "${hostname}";
    destination = [];
    relayDomains = [];

    sslCACert = "/etc/letsencrypt/live/${hostname}/chain.pem";
    sslCert = "/etc/letsencrypt/live/${hostname}/cert.pem";
    sslKey = "/etc/letsencrypt/live/${hostname}/privkey.pem";

    # Enable submission and handle authentication with Dovecot
    enableSubmission = true;
    submissionOptions = {
      smtpd_tls_security_level = "encrypt";
      smtpd_sasl_auth_enable = "yes";
      smtpd_sasl_type = "dovecot";
      smtpd_sasl_path = "private/auth";
      smtpd_sasl_security_options = "noanonymous";
      smtpd_sasl_local_domain = "${hostname}";
      smtpd_client_restrictions = "permit_sasl_authenticated,reject";
      smtpd_recipient_restrictions = "reject_non_fqdn_recipient,reject_unknown_recipient_domain,permit_sasl_authenticated,reject";
    };

    recipientDelimiter = "+";

    extraConfig = ''
        virtual_transport = lmtp:unix:private/dovecot-lmtp
        virtual_mailbox_domains = mysql:${virtualMailboxDomains}
        virtual_mailbox_maps = mysql:${virtualMailboxMaps}
        virtual_alias_maps = mysql:${virtualAliasMaps}, mysql:${virtualEmail2Email}
    '';
  };

  networking.firewall.allowedTCPPorts = [ 25 587 993 ];

  environment.systemPackages = with pkgs; [
    certbot
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    postfix = pkgs.postfix.override { withMySQL = true; };
    dovecot = pkgs.dovecot.override { withMySQL = true; };
  };
}
