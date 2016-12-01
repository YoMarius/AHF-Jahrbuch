<?php require_once( "db.php" );

define( "MOODLE_LOGIN_OK",              0 );
define( "MOODLE_LOGIN_WRONG_CRED",      1 );
define( "MOODLE_NO_CONNECTION",         2 );
define( "MOODLE_GET_DATA_ERROR",        3 );
define( "MOODLE_GET_DATA_OK",           4 );
define( "REGISTRATION_USER_EXISTS",     5 );
define( "REGISTRATION_WRITE_SQL_ERROR", 6 );
define( "REGISTRATION_SUCCESSFULL",     7 );

class Registration {

	//#######
	//#
	//#	    Holds the error code
	//#
	//#######
	private $error;
	
	//#######
	//#
	//#	    Returns the error code
	//#
	//#######
	public function getError() { return $this->error; }
	
	//#######
	//#
	//#	    Returns the error message
	//#
	//#######
	public function getErrorMessage() {
		switch( $this->error ) {
			case MOODLE_LOGIN_WRONG_CRED     : return "Falsche Moodle Anmeldedaten.";
			case MOODLE_GET_DATA_ERROR       : return "Es gibt ein Problem mit Moodle";
			case REGISTRATION_USER_EXISTS    : return "Du hast dich bereits registriert";
			case REGISTRATION_WRITE_SQL_ERROR: return "Es gibt ein Problem mit der Datenbank";
		}
	}
	
	
	//#######
	//#
	//#	    Registrated user id
	//#
	//#######
	public $user = false;

	//#######
	//#
	//#	    Logs into Moodle to validate the User
	//#
	//#######
	protected function moodleLogin( $username, $password ) {
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, "https://moodle.ahfs-detmold.de/gymnasium/login/index.php");
		curl_setopt($ch, CURLOPT_HEADER, True);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, True);
		curl_setopt($ch, CURLOPT_REFERER, "https://moodle.ahfs-detmold.de/gymnasium/user/");
		curl_setopt($ch, CURLOPT_COOKIE, "MoodleSession=0");
		curl_setopt($ch, CURLOPT_POST, True);
		curl_setopt($ch, CURLOPT_POSTFIELDS, "username=$username&password=$password");
		$data = curl_exec($ch);
		curl_close($ch);
		$location = "";
		$token = false;
		$data = preg_split ('/[\n\r]/', $data);
		foreach( $data as $line ) {
			$line = explode( ": ", $line );
			if( $line[0] == "Location") {
				if( $line[1] == "http://moodle.ahfs-detmold.de/gymnasium/login/index.php" ) return [ "status"=>MOODLE_LOGIN_WRONG_CRED, "token"=>$token ];
				$location = $line[1];
			}
			if( $line[0] == "Set-Cookie") {
				if( explode("=", $line[1])[0] == "MoodleSession" ) {
						$token = explode( ";", explode("=", $line[1])[1] )[0];
				}
			}
		}
		$c = curl_init();
		curl_setopt($c, CURLOPT_URL, $location);
		curl_setopt($c, CURLOPT_RETURNTRANSFER, True);
		curl_setopt($c, CURLOPT_HEADER, True);
		curl_setopt($c, CURLOPT_COOKIE, "MoodleSession=$token");		
		$data = curl_exec($c);
		return [ "status"=>MOODLE_LOGIN_OK, "token"=>$token ];
	}
	//#######
	//#
	//#	    Retrives the First and last nmae From Moodle
	//#
	//#######
	protected function getMoodleData( $token ) {
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, "https://moodle.ahfs-detmold.de/gymnasium/user/");
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, True);
		curl_setopt($ch, CURLOPT_COOKIE, "MoodleSession=$token");
				
		$data = curl_exec($ch);
		curl_close($ch);
		if( preg_match( '/anzeigen"\s*>(([\w|\s]*)\s(\w*))</i', $data, $matches ) != 1 ) return [ "status"=>MOODLE_GET_DATA_ERROR, "name"=>["",""] ];
		return ["status"=>MOODLE_GET_DATA_OK, "name"=>[$matches[2],$matches[3]] ];
	}
	//#######
	//#
	//#	    Write the gathered Information into the Database
	//#
	//#######
	protected function writeEntry( $nm, $pw, $fn, $ln ) {
		$db = connectDB();
		if( !$db ) {error_log($db->error);return REGISTRATION_WRITE_SQL_ERROR;}
		if(!($result = $db->query( "SELECT `id` FROM `login_info` WHERE `id` Like '$nm'" ) ) ) {error_log($db->error);return REGISTRATION_WRITE_SQL_ERROR;}
		if( $result->num_rows > 0 ) return REGISTRATION_USER_EXISTS;
		if(!($result = $db->query( "INSERT INTO `login_info` ( id, password ) VALUES ( '$nm', '$pw' )" ) ) )   {error_log($db->error);return REGISTRATION_WRITE_SQL_ERROR;}
		if(!($result = $db->query( "INSERT INTO `profiles` ( user_id, fname, lname ) VALUES ( '$nm', '$fn', '$ln' )" ) ) ) {error_log($db->error);return REGISTRATION_WRITE_SQL_ERROR;}
		return REGISTRATION_SUCCESSFULL;
	}
	
	//#######
	//#
	//#	    Merges all the steps and checks for errors
	//#
	//#######
	public function register( $username, $password ) {
		$moodleLogin = $this->moodleLogin( $username, $password );
		if( $moodleLogin["status"] != MOODLE_LOGIN_OK ) {
			$this->error = $moodleLogin["status"];
			return false;
		}
		$moodleData = $this->getMoodleData( $moodleLogin["token"] );
		if( $moodleData["status"] != MOODLE_GET_DATA_OK ) {
			$this->error = $moodleData["status"];
			return false;
		}
		$password = md5( $password );
		$status = $this->writeEntry( $username, $password, $moodleData["name"][0], $moodleData["name"][1] );
		if( $status != REGISTRATION_SUCCESSFULL ) {
			$this->error = $status;
			return false;
		}
		$l = new Login( md5( $username.$password.$_SERVER['REQUEST_TIME'] ) );
		$this->error = false;
		return $l;
	}
	
}


?>
