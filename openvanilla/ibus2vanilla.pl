# ============================================================
# convert the iBus Zhengma table to the format used by OpenVanilla
# iBus:        key    character    frequency
# OpenVanilla: key    character
# 2012-07-12
# ============================================================
use warnings;
use strict;

my $line      = "";
my $last_line = "";
my ( $input, $output ) = ( undef, undef );
my %dict;
my @key_char_freq;
my ( $key, $char, $freq );
my $last_key = "";
my @keys     = ();
my @chars    = ();
my @freqs    = ();

open $input,  "<", "zhengma.txt" or die "@!";
open $output, ">", "zhengma.cin" or die "@!";

sub process_triplets {
    my ( $keys, $chars, $freqs ) = @_;
    my @orders = ();
    @orders = sort { $$freqs[$b] <=> $$freqs[$a] } 0 .. $#freqs;
    for my $order (@orders) {
        print $output ${$keys}[$order], " ", ${$chars}[$order],

          #						" ", ${$freqs}[$order],
          "\n";
    }

}

while ( $line = <$input> ) {
    @key_char_freq = split /\s+/, $line;

    #	print "@key_char_freq", "\n";
    $key  = $key_char_freq[0];
    $char = $key_char_freq[1];
    $freq = $key_char_freq[2];
    if ( ( $last_key ne $key ) && ( $last_key ne "" ) ) {
        &process_triplets( \@keys, \@chars, \@freqs );
        @keys  = ();
        @chars = ();
        @freqs = ();
    }
    push @keys,  $key;
    push @chars, $char;
    push @freqs, $freq;
    $last_key = $key;
}
&process_triplets( \@keys, \@chars, \@freqs );

close $output;
close $input;
__END__
: main()
* for each line
* get triplet key_char_freq
* check if key exists
** yes -> store key_char_freq -> next line
** no -> now comes the new key -> process stored key_char_freq -> write to file -> new line

: sub process stored triplets
* compare the freq for the same key, rearrange them by sort by the freq

: sub write to file
* for each rearranged key write dulets key_char to file,  print line
