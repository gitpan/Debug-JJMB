package Debug;

use 5.006;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Debug ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);
our $VERSION = '0.01';


# Preloaded methods go here.
my $package = __PACKAGE__;
my $dfh = "";
local *DFH;

# new() - creates a new Debug object.
sub new {
	my $class = shift;
	my $debug = shift || 1;
	my $self = {};
	
	$self->{'DEBUG'} = $debug if defined $debug;

	bless $self, $class;
	return $self;
}

# timeStamp() - enables date and timestamped messages
sub timeStamp() {
	my $self = shift;
	my $timestamp = shift || 1;
	
	$self->{'TIMESTAMP'} = $timestamp if defined $timestamp;
	
	return $self->{'TIMESTAMP'};
}

# detail() - enables detailed messages including line of code and callers
sub detail() {
	my $self = shift;
	my $detail = shift || 1;
	
	$self->{'DETAIL'} = $detail if defined $detail;
	
	return $self->{'DETAIL'};
}

# debug() - enabled normal messages
sub debug {
	my $self = shift;
	my $debug = shift;
	
	$self->{'DEBUG'} = $debug if defined $debug;
	
	return $self->{'DEBUG'};
}

# debugFile() - sets debug file 
sub debugFile {
	my $self = shift;
	my $debugfile = shift;
	
	$self->{'DEBUGFILE'} = $debugfile if defined $debugfile;
	
	return $self->{'DEBUGFILE'};
}

# initialize() - initialize logging
sub initialize {
	my $self = shift;

	if (($self->{'DEBUG'}) && ($self->{'DEBUGFILE'}))
	{
		open(FH,"+>> $self->{'DEBUGFILE'}") || die print STDERR "error:($package):could not open $self->{'DEBUGFILE'}.\n";
		*DFH = *FH;
		print STDERR "Logging to $self->{'DEBUGFILE'}\n";
	}
	elsif (($self->{'DEBUG'}) && (!defined($self->{'DEBUGFILE'})))
	{
		open(FH,">&STDOUT") || die print STDERR "error:($package):could not open STDERR.\n";
		*DFH = *FH;
		print STDERR "Logging to STDOUT\n";
	}
	else
	{
		open(FH,"+>> /dev/null") || die print STDERR "error:($package):could not open /dev/null.\n";
		*DFH = *FH;
		print STDERR "Logging to /dev/null\n";
	}

	select((select(DFH),$| = 1)[0]);

	if (*DFH)
	{
		print DFH "debug:($package): initialized.\n" || 
		die print STDERR "error:($package):could not write to ".$self->debugfilehandle().".\n";
	}
	else
	{
		print STDERR "error:($package) debug file handle does not exist.\n";
	}

	return $self;
}

# message() - writes message
sub message {
	my $self = shift;
	# my $message = shift || "null";
	my $message = shift;
	my $datetime = undef;
	my $origin = undef;
	my $msg = undef;
	
	if($message eq "") {
		$message = "null";
	}

	if($self->{'TIMESTAMP'}) {
		my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(time);
		$datetime = sprintf("%04d-%02d-%02d.%02d:%02d:%02d",$year+1900,$mon+1,$mday,$hour,$min,$sec);
		
		$msg .= "[".$datetime."]:";
		# $msg .= $message;
		# print DFH "[".$datetime."]".$message."\n";
	}
	
	if($self->{'DETAIL'}) {
		# my $origin = (caller(0))[0]."->".(caller(0))[2]."->".(caller(0))[3];
		# my $origin = (caller(0))[0]."->".(caller(0))[3];
		$origin = (caller(0))[0];
		
		# Uncomment to add file name back to debug output
		# $origin .= "->".(caller())[1];
		
		# Line number
		$origin .= "(".(caller())[2].")";
		
		# Called module and function
		$origin .= "->".(caller(0))[3];
		
		$msg .= "[".$origin."]:";
		# print DFH "[".$origin."]:".$message."\n";
	}
	
	$msg .= $message;

	# print DFH "[".$datetime."]".":[".$origin."]:".$message."\n";
	print DFH $msg."\n";
}

1;
__END__
# Below is stub documentation for your module.

=head1 NAME

Debug - Perl extension for logging/debugging.

=head1 SYNOPSIS

  use Debug;

=head1 DESCRIPTION

Debug provide a basic framework for the logging/debugging of Perl modules.

new()
Create a new Debug object

timeStamp()
Enables date and timestamping

detail()
Enables detailed logging

debug
Enables debugging

debugFile
Set a debug file for logging to a file

initialize
Initializes debugging/logging

message	
Write a message to configured destinations

my $debug = new Debug();
$debug->debugFile("debug.log");
$debug->initialize();
$debug->message("Test 1");
$debug->timeStamp();
$debug->message("Test 2");
$debug->detail();
$debug->message("Test 3");

=head2 EXPORT

None by default.

=head1 AUTHOR

JJMB, <lt>jjmb@jjmb.comE<gt>

=head1 SEE ALSO

L<perl>.

=cut
