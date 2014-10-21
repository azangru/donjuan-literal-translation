#!/bin/env perl
use strict;
use Getopt::Long;
use Pod::Usage;

my %opts = ();
my $help = 0;
my $txtid = 1;
my $comid = 1;

my $stat = GetOptions(
  'in|i=s', \$opts{in},
  'out|o=s', \$opts{out},
  'help|?' => \$help);
pod2usage(-exitval => 0, -verbose => 1) if $help;
die "need both input and output files\n" unless length($opts{in}) and length($opts{out});
die "input file `$opts{in}' does not exist\n" unless -f $opts{in};
#die "output file `$opts{in}' exists\n" if -f $opts{out};

main();

#---------------------------------------------

sub main {
  my $dj = join("<br/>",fin($opts{in})); # reads the file in whole
  $dj = comref($dj); # separates comments from main text; creates IDs and crossrefs; formats html
  fout($opts{out}, [$dj]); # write html out
}

sub comref {
  my $text = shift;
  # initializes main text (head) and comments (tail)
  my ($head,$tail) = ("<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\"><h2>=== MAIN TEXT ===</h2>", "<h2>=== COMMENTS ===</h2>");
  while( $text =~ /\[\[(.*?)\]\]/ ) { # searches for the next comment between [[ and ]]
    $head .= $`; # keeps the text before the comment (PREMATCH)
    my $comment = $1; # remembers the value of the regex group above
    my ($txt,$refs) = mk_refs($comment); # separates text (before the first |) from the comments; returns both, formatted
    $head .= $txt;
    $tail .= $refs;
    $text = $' # takes what's left after the comment (POSTMATCH)
  }
  $head .= $text;
  $head . $tail
}

sub mk_refs {
  my $comment = shift;
  my @coms = split(/\|/, $comment);
  my $body = shift @coms; # the fragment of the main text before the first comment
  my $txt = qq(<a name="txt_$txtid">$body</a>);
  my $ref = qq(<p>);
  my $comidx = 1;
  for my $com ( @coms ) { # makes crossrefs out of the text fragment and the comments
    $txt .= qq( <sup><a href="#com_${comid}_$comidx">[$comid.$comidx]</a></sup>);
    $ref .= qq(<a name="com_${comid}_$comidx">[$comid.$comidx]</a> <a href="#txt_$txtid">^</a> $com</br>);
    $comidx++;
  }
  $txtid++;
  $comid++;
  ($txt,$ref)
}

#---------------------------------------------

# reads a whole file into an array of lines
sub fin {
  open my $fh, "<", $_[0] or die "!$!\n";
  my @lines = readline($fh);
  close $fh;
  return map { chomp; $_ } @lines
}

# outputs an array of lines into a file
sub fout { fw($_[0],$_[1],'>') }

sub fw {
  open my $fh, $_[2], $_[0] or die "!$!\n";
  print $fh "$_\n" for @{$_[1]};
  close $fh
}

__END__

=head1 SYNOPSIS

dj2html -in file -o file

=cut

