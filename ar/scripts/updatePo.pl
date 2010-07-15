#!/usr/bin/perl

use strict;
use warnings;
use Cwd;

my $url=`elinks --dump http://www.nvda-project.org/wiki/Snapshots | grep -i '.pot' | head -n 1 | awk '{ print \$2 }'`;
my $bname;
my $dname;
my $cmd;
my $pwd;

if ($url !~ /^http.*?\.pot$/ ) {
print "We didn't find the url.\n";
exit;
}

$bname=`basename "$url"`;
$cmd=`curl -s -o /tmp/nvda.pot $url`;
$pwd = Cwd::cwd();
$dname=`dirname "$pwd"`;
chomp $dname;
$cmd=`cd ../; git checkout nvda.po; git svn rebase`;

# before
my $bfuzzy = `pocount $dname/nvda.po | grep -i fuzzy | awk '{print \$2}'`;
chomp $bfuzzy;
my $buntranslated = `pocount $dname/nvda.po | grep -i untranslated | awk '{print \$2}'`;
chomp $buntranslated;
my $bmsg = $bfuzzy . " fuzzy messages, and " . $buntranslated . " untranslated messages.";

$cmd=`msgmerge -U $dname/nvda.po /tmp/nvda.pot 2>&1 `;

# after
my $afuzzy = `pocount $dname/nvda.po | grep -i fuzzy | awk '{print \$2}'`;
chomp $afuzzy;
my $auntranslated = `pocount $dname/nvda.po | grep -i untranslated | awk '{print \$2}'`;
chomp $auntranslated;
my $amsg = $afuzzy . " fuzzy messages, and " . $auntranslated . " untranslated messages.";

if ($bmsg eq $amsg) {
# nothing has changed, dont need to action.
# revert because comments in po file might have changed.
#
$cmd = `git checkout ../nvda.po`;
print "nvda.po file is up to date, nothing to do.\n";
} else {
# need to commit, because before and after are diffrent.
#
my $commitMsg = "Automatic commit for nvda.po\n\n" .
"before: " . $bmsg . "\nNow: " . $amsg . "\n";
$cmd=`git commit -m "$commitMsg" ../nvda.po; git svn dcommit`;
}
