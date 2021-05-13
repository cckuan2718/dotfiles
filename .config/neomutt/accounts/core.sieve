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
if header :contains "X-Spam" ["YES", "yes"] {
	fileinto :create "Spam";
	stop;
}

# Finance/Bank
if address :domain "From" "tcb-bank.com.tw" {

	fileinto :create "Finance";

# Mailing lists
} elsif anyof (header :is "Precedence" ["list", "bulk"], exists "List-Id") {

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

