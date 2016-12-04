<?php require_once( "db.php" );

class Group {

	private $id;
	private $name;
	private $description;
	private $members;
	
	public function Group( $id ) {
		$this->id = $id;
		$this->loadMeta();
		$this->loadMembers();
	}
	
	public static function getGroups() {
		if(!($db = connectDB()) ) return false;
		if(!($result = $db->query( "SELECT * FROM `group_meta`") ) ) return false;
		$ret = []; while(($e = $result->fetch_array(MYSQL_ASSOC))) { $ret[] = $e; }
		return $ret;
	}
	public static function getGroup( $id ) {
		return new Group( $id );
	}
	
	private function loadMeta() {
		$db = connectDB();
		$id = $this->id;
		if( !($r = $db->query( "SELECT * FROM `group_meta` WHERE `group_id` Like $id" ) ) ) return;
		if( !($r = $r->fetch_array(MYSQL_ASSOC)) ) return;
		$this->name = $r["name"];
		$this->description = $r["description"];
	}
	private function loadMembers() {
		if(!($db = connectDB()) ) return false;
		$id = $this->id;
		if(!($result = $db->query( "SELECT `user_id` FROM `group_participants` WHERE `group_id` Like $id") ) ) return false;
		$ret = []; while(($e = $result->fetch_array(MYSQL_ASSOC))) {
			try { $p = new Profile( $e["user_id"], false ); }
			catch( Exception $e ) { continue; }
			$ret[] = $p;
		}
		$this->members = $ret;
	}
	
	public function getName() {
		return $this->name;
	}
	public function getDescription() {
		return $this->description;
	}
	public function getMembers() {
		return $this->members;
	}
	
	public function setMeta( $name, $dsc ) {
		$db = connectDB();
		$id = $this->id; $db->query( "UPDATE `group_meta` SET `name`='$name', `description`='$dsc' WHERE `group_id` Like $id" );
		loadMeta();
	}
	public function addMember( $usr ) {
		$db = connectDB();
		if( $this->isMember( $usr ) ) return true;
		$id = $this->id; $db->query( "INSERT INTO `group_participants` SET `group_id`='$id', `$user_id`='$usr', `mod`=0" );
	}
	public function removeMember( $id ) {
		$db = connectDB();
		$id = $this->id; $db->query( "DELETE FROM `group_participants` WHERE `user_id` Like $id" );
		loadMembers();
	}
	
	
	public static function removeGroup() {
		$db = connectDB();
		$id = $this->id;
		$db->query( "DELETE FROM `group_meta` WHERE `group_id` Like $id" );
		$db->query( "DELETE FROM `group_participants` WHERE `group_id` Like $id" );
	}
	public static function createGroup( $name, $desc ) {
		$db = connectDB();
		$id = $this->id;
		if( $db->query( "INSERT INTO `group_meta` SET `name`='$name', `description`='$desc'" ) ) return;
		return new Group( $db->query("SELECT LAST_INSERT_ID()")->fetch_array(MYSQL_NUM)[0] );
	}
	
	
	public function isMember( $user ) {
		if(!($db = connectDB()) ) {$this->error=LOGIN_MYSQL_ERROR;return false;}
		$id = $this->id; if(!($result = $db->query( "SELECT 1 FROM `group_participants` WHERE `group_id` Like '$id' AND `user_id` Like '$user'") ) ) return false;
		return $result->num_rows > 0;
	}
	
	public static function inGroups($user) {
		if(!($db = connectDB()) ) {$this->error=LOGIN_MYSQL_ERROR;return false;}
		if(!($result = $db->query( "SELECT * FROM `group_meta` as a LEFT JOIN `group_participants` as b ON a.`group_id` LIKE b.`group_id` WHERE b.`user_id` LIKE 'LukaNagel99'") ) ) return false;
		$ret = []; while(($e = $result->fetch_array(MYSQL_ASSOC))) { $ret[] = $e; }
		return $ret;
	}
	//#######
	//#
	//#	    Checks if given user is moderator by user id 
	//#
	//#######
	static function isMod( $group, $user ) {
		if( Login::isAdmin($user) ) return true;
		if(!($db = connectDB()) ) {$this->error=LOGIN_MYSQL_ERROR;return false;}
		if(!($result = $db->query( "SELECT 1 FROM `group_participants` WHERE `group_id` Like '$group' AND `user_id` Like '$user' AND `mod` Like 1") ) ) return false;
		return $result->num_rows > 0;
	}
	//#######
	//#
	//#	    Grants moderator rights to User by user id
	//#
	//#######
	public static function grantMod( $user, $usr, $group ) {
		if( Group::isMod( $user ) ) {
			if(!($db = connectDB()) ) {$this->error=LOGIN_MYSQL_ERROR;return false;}
			if(!($result = $db->query( "UPDATE `group_participants` SET `mod`=1 WHERE `user_id` Like '$usr' AND `group_id` Like '$group'") ) ) return false;
			$log( "Groups", "$usr granted $user moderator rights for group $group" );
			return $result->num_rows > 0;
		}
	}
	//#######
	//#
	//#	    Revokes moderator rights to User by user id
	//#
	//#######
	public static function revokeMod( $user, $usr, $group) {
		if( Group::isMod( $user ) ) {
			if(!($db = connectDB()) ) {$this->error=LOGIN_MYSQL_ERROR;return false;}
			if(!($result = $db->query( "UPDATE `group_participants` SET `mod`=0 WHERE `user_id` Like '$usr' AND `group_id` Like '$group'") ) ) return false;
			$log( "Profile", "$usr revoked $user moderator rights for group $group" );
			return $result->num_rows > 0;
		}
	}

}

?>
