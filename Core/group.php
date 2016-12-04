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
	public function getID() {
		return $this->id;
	}

	public function setMeta( $name, $dsc ) {
		$db = connectDB();
		$id = $this->id; $db->query( "UPDATE `group_meta` SET `name`='$name', `description`='$dsc' WHERE `group_id` Like $id" );
		loadMeta();
	}
	public function addMember( $user ) {
		$db = connectDB();
		if( $this->isMember( $uid ) ) return true;
		$id = $this->id; $db->query( "INSERT INTO `group_participants` (`group_id`, `user_id`, `mod`) VALUES ('$id','$user', 0)" );
	}
	public function removeMember( $user ) {
		$db = connectDB();
		$id = $this->id; $db->query( "DELETE FROM `group_participants` WHERE `group_id` LIKE '$id' AND `user_id` LIKE '$user'" );
	}


	public static function removeGroup() {
		$db = connectDB();
		$id = $this->id; $db->query( "DELETE FROM `group_meta` WHERE `group_id` Like $id" );
		$db->query( "DELETE FROM `group_participants` WHERE `group_id` Like $id" );
	}
	public static function createGroup( $name, $desc ) {
		$db = connectDB();
		if( $db->query( "INSERT INTO `group_meta` SET `name`='$name', `description`='$desc'" ) ) return;
		return new Group( $db->query("SELECT LAST_INSERT_ID()")->fetch_array(MYSQL_NUM)[0] );
	}
	public static function addGroup( $name, $desc ) {
		return createGroup( $name, $desc );
	}


	public function isMember( $user ) {
		if(!($db = connectDB()) ) return false;
		$id = $this->id;if(!($result = $db->query( "SELECT 1 FROM `group_participants` WHERE `group_id` Like '$id' AND `user_id` Like '$user'") ) ) return false;
		return $result->num_rows > 0;
	}
	public static function inGroups($user) {
		if(!($db = connectDB()) ) return false;
		if(!($result = $db->query( "SELECT * FROM `group_meta` as a LEFT JOIN `group_participants` as b ON a.`group_id` LIKE b.`group_id` WHERE b.`user_id` LIKE 'LukaNagel99'") ) ) return false;
		$ret = []; while(($e = $result->fetch_array(MYSQL_ASSOC))) { $ret[] = $e; }
		return $ret;
	}
	//#######
	//#
	//#	    Checks if given user is moderator by user id
	//#
	//#######
	public static function isMod( $group, $user, $ignoreadmin=false ) {
		if( Login::isAdmin($user) && !$ignoreadmin ) return true;
		if(!($db = connectDB()) ) return false;
		if(!($result = $db->query( "SELECT 1 FROM `group_participants` WHERE `group_id` Like '$group' AND `user_id` Like '$user' AND `mod` Like 1") ) ) return false;
		return $result->num_rows > 0;
	}
	public static function hasModPriv( $group, $user ) {
		Group::isMod( $group, $user, true );
	}
	//#######
	//#
	//#	    Grants moderator rights to User by user id
	//#
	//#######
	public static function grantMod(  $usr, $user, $group ) {
		if( !Group::isMod( $usr ) ) return false;
			if(!($db = connectDB()) ) return false;
			$result = $db->query( "UPDATE `group_participants` SET `mod`=1 WHERE `group_id` Like '$group' AND `user_id` Like '$usr'");
			Log::msg( "Groups", "$usr granted $user moderator rights in $group" );
			return $result->num_rows > 0;
	}
	//#######
	//#
	//#	    Revokes moderator rights to User by user id
	//#
	//#######
	public static function revokeMod(  $usr, $user, $group ) {
			if( !Group::isMod( $usr ) ) return false;
			if(!($db = connectDB()) ) return false;
			$result = $db->query( "UPDATE `group_participants` SET `mod`=0 WHERE `group_id` Like '$group' AND `user_id` Like '$usr'");
			Log::msg( "Groups", "$usr revoked $user moderator rights in $group" );
			return $result->num_rows > 0;
	}

}

?>
