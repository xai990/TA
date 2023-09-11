#!/usr/bin/perl
# enter each directory and execute make clean; make
#
# this is dangerous if a student submits a rogue makefile!
#

# loop through each file and directory at current location
foreach $user (<*>) {

    if (-d $user) {
        if ($user eq "empty") { 
            next;
        }
        if ($user eq "tests") {
            next;
        }
	print "$user\n";
    }
    else {
        # print "not a user directory: $user\n";
	next;
    }
    # check for missing makefile 
    # or, we could move student's makefile out of the way
    # and always use our own.  Unless a student changes the file names
    $mfile = $user.'/makefile'; 
    $runfile = $user.'/run.sh';
    $valrunfile = $user.'/valrun.sh';
    $checkfile = $user.'/check.pl';
    #
    # to clean old versions
    `rm -f $runfile $valrunfile $checkfile`;
    unless (-f $mfile) {
        # copy a generic makefile if available
        if (-f 'tests/makefile') {
           `cp tests/makefile $user`;
           unless (-f $mfile) {
               die "how did copy fail?\n";
           }
        }
        else {
            print "   --file not found: $mfile\n";
            next;
        }
    }
    unless (-f $runfile) {
        if (-f 'tests/run.sh') {
            `cp tests/run.sh $user`;
        }
    }
    unless (-f $valrunfile) {
        if (-f 'tests/valrun.sh') {
            `cp tests/valrun.sh $user`;
        }
    }
    unless (-f $checkfile) {
        if (-f 'tests/check.pl') {
            `cp tests/check.pl $user`;
        }
    }

    # backtick executes a command and collects stdout 
    # stderr is not collected but goes to output, or use 2> to send stderr to file

    $info = `cd $user; make clean; make; cd ..`;
    #
    # with design checks
    $info = `cd $user; make design; cd ..`;
    if ($info ne "") {
        print "\t Design errors:\n $info";
    }

    # files as found in users directory
    my $inputf = '../tests/testinput.txt';
    my $grade = 'gradingout_testinput'; 
    my $val = 'gradingout_valtestinput'; 

    # faster test
    #$info = `cd $user; ./lab1 3 < $inputf > $grade; cd ..`;

    # valgrind is slower
    $info = `cd $user; valgrind --leak-check=yes ./lab1 3 < $inputf > $grade 2> $val; cd ..`;

    $info = `diff -w $user/$grade tests/expectedoutput.txt`;
#    #print "the status is $?\n";
    if ($? > 0) {
        print "There is a diff in expected\n";
        print "the info is: $info\n";
    }
    my $uservalfile = $user.'/'.$val;
    if (-f $uservalfile) {
        $info = `grep "no leaks" $uservalfile`;
        if ($info eq "") {
            $info = `grep "total heap usag" $uservalfile`;
            print "\tfound leaks: $info";
        }
        $info = `grep "0 errors" $uservalfile`;
        if ($info eq "") {
            $info = `grep "ERROR SUMMARY" $uservalfile`;
            print "\t$info\n";
        }
    }
}

    # for example, if we want to see only the errors and
    # warnings we can ignore the stdout.  To see stdout:
    # print "the info is: $info\n";
    # print "the status is $?\n";

    # system executes a command but only gets final return value
    # all output just goes to stdout
    #
    # $make = "cd $user; make clean; make; cd ..";
    # $rc = 0xffff & system $make;
    # if ($rc != 0) {
    #     die "system $make failed: $?";
    # }

#    a more elaborate way to test return value
#    $rc = 0xffff & system $make;
#    if ($rc == 0) {
#        print "ran with normal exit\n";
#    }
#    elsif ($rc == 0xff00) {
#        print "command failed: $!\n";
#    }
#    elsif (($rc & 0xff) == 0) {
#        $rc >>= 8;
#        print "ran with non-zero exit status $rc\n";
#    }
#    else {
#        print "ran with ";
#        if ($rc & 0x80) {
#            $rc &= ~0x80;
#            print "coredump from ";
#        }
#        print "signal $rc\n";
#    }

# reg expression  (upper case negates the following)
#   \d [0-9]
#   \w [a-zA-Z0-9_]
#   \s [ \r\t\n\f]
#   * zero or more
#   + one or more
#   ? zero or one

# File tests
#     -x file or directory is executable
#     -e file or directory exists
#     -z file exists and has zero size
#     -s non zero size
#     -f a file
#     -d a directory
#

