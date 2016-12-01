<?php require_once( "db.php" );

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

		protected function loadBasicInfo( ) {
			if(!($db = connectDB()) ) return false;
			$id = $this->id; if(!($result = $db->query("SELECT `FName`, `LName` FROM `profiles` WHERE `user_id` Like '$id'") ) ) return false;
			if( $result->num_rows == 0 )  return false;
			$ret = $result->fetch_array(MYSQL_ASSOC);
			$this->first_name = $ret["FName"];
			$this->last_name = $ret["LName"];
			return true;
		}

		protected function loadFields() {
			if(!($db = connectDB()) ) return false;
			$id = $this->id;if(!($result = $db->query("SELECT `field_id`, `field_title`, `value`, `field_type`, `field_opt` FROM `profile_meta_fields` LEFT JOIN (SELECT * FROM `profile_user_fields` WHERE `user_id` Like '$id') as `values` ON `field_id` Like `meta_field_id` ORDER BY `field_order`") ) ) return false;
			if( $result->num_rows == 0 )  return false;
			$ret = []; while(($e = $result->fetch_array(MYSQL_ASSOC))) { $ret[] = $e; }
			$this->fields = $ret;
			return true;
		}

		public function changeInfo( $fname, $lname ) {
			if(!($db = connectDB()) ) return false;
			$usr_id = $this->id;
			if( !$db->query("SELECT 1 FROM `profiles` WHERE `user_id` Like '$usr_id'") ) {
			if(!($result = $db->query("INSERT INTO `profile` (`user_id`,`FName`,`LName`) VALUES ('$usr_id','$fname', '$lname')") ) ) return false;
			} else
			if(!($result = $db->query("UPDATE `profiles` SET `FName`='$fname',`LName`='$lname' WHERE `user_id` Like '$usr_id'") ) ) return false;
			$this->loadBasicInfo();
			return true;
		}

		public function changeField( $field_id, $value ) {
			if(!($db = connectDB()) ) return false;
			$usr_id = $this->id;
			if( $db->query("SELECT 1 FROM `profile_user_fields` WHERE `meta_field_id` Like $field_id")->num_rows == 0 ) {
			if(!($result = $db->query("INSERT INTO `profile_user_fields` ( `meta_field_id`, `user_id`, `value` ) VALUES ( '$field_id', '$usr_id', '$value' )") ) ) return false;
			} else
			if(!($result = $db->query("UPDATE `profile_user_fields` SET `value`='$value' WHERE `meta_field_id` Like '$field_id' AND `user_id` Like '$usr_id'") ) ) return false;
			$this->loadFields();
			return true;
		}

		public static function listProfiles() {
			if(!($db = connectDB()) ) return false;
			if(!($result = $db->query( "SELECT * FROM `profiles`") ) ) return false;
			$ret = []; while(($e = $result->fetch_array(MYSQL_ASSOC))) { $ret[] = $e; }
			return $ret;
		}

		public static function getProfile( $id, $load_fields=true ) {
			return new Profile( $id, $load_fields );
		}

		public static function userExists( $id ) {
			if(!($db = connectDB()) ) return false;
			if(!($result = $db->query("SELECT * FROM `login_info` WHERE `id` Like '$id'") ) ) return false;
			if( $result->num_rows == 0 )  return false;
			return true;
		}

	}

?>
