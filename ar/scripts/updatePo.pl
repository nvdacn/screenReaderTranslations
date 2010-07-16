#!/usr/bin/perl

use strict;
use warnings;
use Cwd;

my $amsg;
my $afuzzy;
my $auntranslated;
my $bname;
my $bfuzzy;
my $buntranslated;
my $bmsg;
my $cmd;
my $commitMsg;
my $dname;
my $msg;
my $pwd;
my $url=`elinks --dump http://www.nvda-project.org/wiki/Snapshots | grep -i '.pot' | head -n 1 | awk '{ print \$2 }'`;

if ($url !~ /^http.*?\.pot$/ ) {
$msg="updatePo.pl: could not find url for nvda.po.\n.";
$cmd=`echo -e "$msg" | mail -s "updatePo.pl: regarding nvda.po file" 'mesar.hameed\@gmail.com'`;
exit;
}

$bname=`basename "$url"`;
$cmd=`curl -s -o /tmp/nvda.pot $url`;
$pwd = Cwd::cwd();
$dname=`dirname "$pwd"`;
chomp $dname;
$cmd=`cd ../; git checkout nvda.po; git svn rebase`;

# before
$bfuzzy = `pocount $dname/nvda.po | grep -i fuzzy | awk '{print \$2}'`;
chomp $bfuzzy;
$buntranslated = `pocount $dname/nvda.po | grep -i untranslated | awk '{print \$2}'`;
chomp $buntranslated;
$bmsg = $bfuzzy . " fuzzy messages, and " . $buntranslated . " untranslated messages.";

$cmd=`msgmerge -U $dname/nvda.po /tmp/nvda.pot 2>&1 `;

# after
$afuzzy = `pocount $dname/nvda.po | grep -i fuzzy | awk '{print \$2}'`;
chomp $afuzzy;
$auntranslated = `pocount $dname/nvda.po | grep -i untranslated | awk '{print \$2}'`;
chomp $auntranslated;
$amsg = $afuzzy . " fuzzy messages, and " . $auntranslated . " untranslated messages.";

if ($bmsg eq $amsg) {
# nothing has changed, dont need to action.
# revert because comments in po file might have changed.
#
$cmd = `git checkout ../nvda.po`;
$msg = "updatePo.pl: nvda.po file is up to date, nothing to do.\n";
$cmd=`echo -e "$msg" | mail -s "updatePo.pl: regarding nvda.po file" 'mesar.hameed\@gmail.com'`;
} else {
# need to commit, because before and after are diffrent.
#
$commitMsg = "Automatic commit for nvda.po\n\n" .
"before: " . $bmsg . "\nNow: " . $amsg . "\n";
$cmd=`git commit -m "$commitMsg" ../nvda.po; ./commit.sh`;
}
