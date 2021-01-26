#
# ~/.dovecot.sieve
#

# Declare extensions
require "date";
require "envelope";
require "fileinto";
require "imap4flags";
require "mailbox";
require "variables";

# Spam
if header :contains "X-Spam" "YES" {
	fileinto :create "Spam";
	stop;
}

# Mailing lists
if anyof (header :is "Precedence" ["list", "bulk"], exists "List-Id") {

	fileinto :create "Mlist";

# Sysadmin
} elsif anyof (exists "X-Cron-Env",
	       header :contains "subject" ["daily insecurity output",
					   "daily output"],
	       address :is "from" "support@vultr.com") {

	fileinto :create "Sysadmin";

# DMARC
} elsif anyof (header :contains "subject" ["Report domain:", "DMARC"]) {

	fileinto :create "DMARC";

# INBOX and archive by year
} else {
	# Extract date info
	if currentdate :matches "year" "*" {
		set "year" "${1}";
	}

	fileinto :create :flags "\\Seen" "Archive/${year}";
	keep;
}

