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
  my $dj = join("\n",fin($opts{in}));
  $dj =~ s#\r?\n\r?\n#<br/><br/>#mg;
  $dj =~ s#r?\n# #mg;
  $dj = comref($dj);
  fout($opts{out}, [$dj]);
}

sub comref {
  my $text = shift;
  my ($head,$tail) = ("<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\"><h2>=== MAIN TEXT ===</h2>", "<h2>=== COMMENTS ===</h2>");
  while( $text =~ /\[\[(.*?)\]\]/ ) {
    $head .= $`;
    my $comment = $1;
    my ($txt,$refs) = mk_refs($comment);
    $head .= $txt;
    $tail .= $refs;
    $text = $'
  }
  $head .= $text;
  $head . $tail
}

sub mk_refs {
  my $comment = shift;
  my @coms = split(/\|/, $comment);
  my $body = shift @coms;
  my $txt = qq(<a name="txt_$txtid">$body</a>);
  my $ref = qq(<p>);
  my $comidx = 1;
  for my $com ( @coms ) {
    $txt .= qq( <sup><a href="#com_${comid}_$comidx">[$comid.$comidx]</a></sup>);
    $ref .= qq(<a name="com_${comid}_$comidx">[$comid.$comidx]</a> <a href="#txt_$txtid">^</a> $com</br>);
    $comidx++;
  }
  $txtid++;
  $comid++;
  ($txt,$ref)
}

#---------------------------------------------

sub fin {
  open my $fh, "<", $_[0] or die "!$!\n";
  my @lines = readline($fh);
  close $fh;
  return map { chomp; $_ } @lines
}

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

