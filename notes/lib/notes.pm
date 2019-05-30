package notes;
use Dancer2;
use utf8;
use Dancer2::Plugin::Database;
use Digest::CRC qw/crc64/;
use HTML::Entities;
#use DBI;
#my $database = DBI->connect("DBI:mysql:dbname=mydb;host=localhost","mydb","mydb") or die "can't connect";

our $VERSION = '0.1';

my $user;
my $users_title;
my $upload_dir = 'note';

sub get_upload_dir {
	print config->{appdir}."\n";
	return config->{appdir}.'/'.$upload_dir.'/';
}

sub insert_to_db {
	my ($type,$name,$smth,$create_time) = @_;
	my $sth = database->prepare('INSERT INTO notes (id, type, col1, col2) VALUES (cast(? as signed),?,?,?)');
	my $id = '';
	my $try_count = 10;
	while (!$id or -f get_upload_dir.$id) {
		database->do('DELETE FROM notes WHERE id = cast(? as signed)',{},$id) if $id;
		unless (--$try_count) {
			$id = undef;
			last;
		}
		$id = crc64($smth.$create_time.$id);
		$id = undef unless $sth->execute($id,$type,$name,$smth);
	}
	unless($id) {
		die "Try later";
	}
	return $id;
}

get '/' => sub {
    return template 'auth';
};

post '/' => sub {
		my $type = params->{operation};
		my $name = params->{name};
		my $password = params->{password};
		$user = $name;
		unless ($type) {
			my $sth = database->prepare('SELECT col2 FROM notes WHERE (type = ?) AND (col1 = ?)');
			$sth->execute(0,$name);
			my $arr = $sth->fetchrow_arrayref();
			unless ($arr) {
				response->status(404);
				warn "smth went wrong";
				redirect '/';
			}
			#todo validate wrong arr
			if ($password eq $arr->[0]) {
				#todo template ok
				redirect '/op';
			}
			else {
				warn "smth went wrong";
				redirect '/';
			}
		} 
		else {
			#template reg
			my $sth = database->prepare('SELECT cast(id as unsigned) FROM notes WHERE (type = ?) AND (col1 = ?)');
			$sth->execute(0,$name);
			my $arr = $sth->fetchrow_arrayref(); 
			unless ($arr) {
				print "ok\n";
				insert_to_db(0,$name,$password,time());
				redirect '/';
			}
			else {
				warn "smth went wrong";
				response->status(404);
				redirect '/';
			}
		}
};


get '/op' => sub{
	template 'operations';
};

post '/op' => sub{
	my $type = params->{operation};
	my $title = params->{title};
	$users_title = $title;
	if ($type == 0){
		redirect '/op/newnote';
	}
	if ($type == 1){
		redirect '/op/editnote';
	}
	if ($type == 2){
		#what about deleting files
		my $sth = database->prepare('SELECT cast(id as unsigned) FROM notes WHERE (type = 1) AND (col1 = ?) AND (col2 = ?)');
		$sth->execute($user,$users_title);
		my $arr = $sth->fetchrow_arrayref();
		if ($arr and -f get_upload_dir.($arr->[0])){
			database->do('DELETE FROM notes WHERE (type = 1) AND (col2 = ?)',{},$title);
			database->do('DELETE FROM notes WHERE (type = 2) AND (col2 = ?)',{},$title);
		}
		else{
			response->status(404);
			warn "smth went wrong";
		}
		redirect '/op';
	}
	if ($type == 3){
		redirect '/op/shownote';
	}
};

get '/op/newnote' => sub{
	return template 'new_note';
};

post '/op/newnote' => sub{
	my $counter = 0;
	my $title = params->{title};
	my $text = params->{note}; 
	my @others = split /,/,params->{names};
	my $id = insert_to_db(1,$user,$title,time());
	for (@others) {
		++$counter;
		insert_to_db(2,$_,$title,time()+$counter);
	}
	my $fh;
	unless (open($fh,'>',get_upload_dir.$id)) {
		die "Internal error";
	}
	print $fh $text;
	close($fh);
	redirect '/op';
};

get '/op/editnote' => sub{
	my @text;
	my $sth = database->prepare('SELECT cast(id as unsigned) FROM notes WHERE (type = 1) AND (col1 = ?) AND (col2 = ?)');
	$sth->execute($user,$users_title);
	my $arr = $sth->fetchrow_arrayref();
	if ($arr and -f get_upload_dir.($arr->[0])){
		my $fh;
		unless (open($fh,'<',get_upload_dir.($arr->[0]))) {
			die "Internal error";
		}
		@text = <$fh>;
		for (@text) {
			$_ = encode_entities($_,'<>&*');
			s/\t/&nbsp;&nbsp;&nbsp;&nbsp;/g;
			s/^ /&nbsp;/g;
		}
		close($fh);
	}
	else{
		response->status(404);
		warn "smth went wrong";
		return template 'operations';
	}
	return template 'edit_note' => {orig => join('',@text)};
};

post '/op/editnote' => sub{
	my $note = params->{note};
	my $sth = database->prepare('SELECT cast(id as unsigned) FROM notes WHERE (type = 1) AND (col1 = ?) AND (col2 = ?)');
	$sth->execute($user,$users_title);
	my $arr = $sth->fetchrow_arrayref();
	if ($arr and -f get_upload_dir.($arr->[0])){
		my $fh;
		unless (open($fh,'>',get_upload_dir.($arr->[0]))) {
			die "Internal error";
		}
		print $fh $note;
		close($fh);
	}
	else{
		response->status(404);
		warn "smth went wrong";
		return template 'operations';
	}
	redirect '/op';
};

get '/op/shownote' => sub{
	my @text;
	my $sth = database->prepare('SELECT cast(id as unsigned) FROM notes WHERE (type = 1) AND (col2 = ?)');
	$sth->execute($users_title);
	my $arr = $sth->fetchrow_arrayref();
	if ($arr and -f get_upload_dir.($arr->[0])){
		my $fh;
		unless (open($fh,'<',get_upload_dir.($arr->[0]))) {
			die "Internal error";
		}
		@text = <$fh>;
		for (@text) {
			$_ = encode_entities($_,'<>&*');
			s/\t/&nbsp;&nbsp;&nbsp;&nbsp;/g;
			s/^ /&nbsp;/g;
		}
		close($fh);
	}
	else{
		response->status(404);
		warn "smth went wrong";
		return template 'operations';
	}
	return template 'show_note' => {orig => join('',@text)};	
};

true;
