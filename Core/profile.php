<?php require_once( "db.php" );

	define( "NOPICPATH", "/media-upload/data/nopic.svg" );

	class Profile {

		public function Profile( $id, $load_fields=true ) {
			$this->id = $id;
			$this->error = $this->error || !$this->loadBasicInfo();
			if( $load_fields ) $this->error = $this->error || !$this->loadFields();
		}

		public $error = false;

		protected $id = "";
		protected $first_name = "No";
		protected $last_name  = "Name";
		protected $fields = [];

		public function getID() {
			return $this->id;
		}
		public function getFirstName() {
			return $this->first_name;
		}
		public function getLastName() {
			return $this->last_name;
		}

		public function getFields() {
			return $this->fields;
		}
		
		public function getAvatar( $modifier="" ) {
			return Profile::_getAvatar($this->id,$modifier);
		}
		public static function _getAvatar( $user, $modifier="" ) {
			$path = "/media-upload/data/$user/avatar$modifier.jpg";
			if( file_exists($_SERVER["DOCUMENT_ROOT"].$path) ) return $path;
			return NOPICPATH;
		}

		protected function loadBasicInfo( ) {
			if(!($db = new DB()) ) return false;
			$id = $this->id; if(!($result = $db->query("SELECT `FName`, `LName` FROM `profiles` WHERE `user_id` Like '§0'",[$id]) ) ) return false;
			if( $result->num_rows == 0 )  return false;
			$ret = $result->fetch_array(MYSQL_ASSOC);
			$this->first_name = $ret["FName"];
			$this->last_name = $ret["LName"];
			return true;
		}

		protected function loadFields() {
			if(!($db = new DB()) ) return false;
			$id = $this->id;if(!($result = $db->query("SELECT `field_id`, `field_title`, `value`, `field_type`, `field_opt` FROM `profile_meta_fields` LEFT JOIN (SELECT * FROM `profile_user_fields` WHERE `user_id` Like '§0') as `values` ON `field_id` Like `meta_field_id` ORDER BY `field_order`",[$id]) ) ) return false;
			if( $result->num_rows == 0 )  return false;
			$ret = []; while(($e = $result->fetch_array(MYSQL_ASSOC))) { $ret[] = $e; }
			$this->fields = $ret;
			return true;
		}

		public function changeInfo( $fname, $lname ) {
			if(!($db = new DB()) ) return false;
			$usr_id = $this->id;
			if(!$db->query("UPDATE `profiles` SET `FName`='§0',`LName`='§1' WHERE `user_id` Like '§2'",[$fname,$lname,$usr_id]) ) return false;
			if( $db->matchedRows($db) == 0 ) if(!$db->query("INSERT INTO `profile` (`user_id`,`FName`,`LName`) VALUES ('§2','§0', '§1')",[$fname,$lname,$usr_id]) ) return false;
			$this->loadBasicInfo();
			return true;
		}

		public function changeField( $field_id, $value ) {
			if(!($db = new DB()) ) return false;
			$usr_id = $this->id;
			if(!$db->query("UPDATE `profile_user_fields` SET `value`='§0',`user_id`='§1' WHERE `meta_field_id` Like '§2' AND `user_id` Like '§1'",[$value,$usr_id,$field_id])) return false;
			if( $db->matchedRows($db) == 0 ) if(!$db->query("INSERT INTO `profile_user_fields` ( `meta_field_id`, `user_id`, `value` ) VALUES ( '§2', '§1', '§0' )",[$value,$usr_id,$field_id])) return false;
			return true;
		}

		public static function listProfiles() {
			if(!($db = new DB()) ) return false;
			if(!($result = $db->query( "SELECT * FROM `profiles` ORDER BY `FName` ASC") ) ) return false;
			$ret = []; while(($e = $result->fetch_array(MYSQL_ASSOC))) { $ret[] = $e; }
			return $ret;
		}

		public static function getProfile( $id, $load_fields=true ) {
			return new Profile( $id, $load_fields );
		}

		public static function userExists( $id ) {
			if(!($db = new DB()) ) return false;
			if(!($result = $db->query("SELECT * FROM `login_info` WHERE `id` Like '§0'", [$id]) ) ) return false;
			if( $result->num_rows == 0 )  return false;
			return true;
		}

	}

?>
