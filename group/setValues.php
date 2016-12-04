<?php require_once $_SERVER["DOCUMENT_ROOT"]."/Core/index.php";
	if( count( $_POST ) > 0 ) {
		$usr = Login::checkUser()["user_id"];
		$g = $_POST["group"]?$_POST["group"]:false;
		if( Group::isMod($g, $usr) ) {
			if( isset($_POST["newgroup"]) ) {
				$g = (Group::addGroup( $_POST["name"], $_POST["desc"] ));
				http_response_code( 302 );
				header( "Location: /profile/me/" );
				return;
			}
			if( !$g ) break;
			if( isset($_POST["name"]) && isset($_POST["desc"]) ) {
				$gr = new Group( $g );
				$gr->setMeta( $_POST["name"], $_POST["desc"] );
				$log( "GROUP", "$usr changed Group($g) to ".$gr->getName() );
				http_response_code( 302 );
				header( "Location: /group/$g/" );
				return;
			}
			if( isset($_POST["addmember"])) {
				$gr = new Group( $g ); $u = $_POST["addmember"];
				$gr->addMember( $u );
				return;
			}
			if( isset($_POST["removeMember"])) {
				$gr = new Group( $g ); $u = $_POST["removeMember"];
				$gr->removeMember( $u );
				return;
			}
			if( isset($_POST["grantMod"])) {
				$gr = new Group( $g ); $u = $_POST["grantMod"];
				$gr->grantMod(  $u, $gr->getID(), $usr );
				echo $gr->getID();
				echo $u;
				return;
			}
			if( isset($_POST["revokeMod"])) {
				$gr = new Group( $g ); $u = $_POST["revokeMod"];
				$gr->revokeMod(  $u, $gr->getID(), $usr );
				echo $gr->getID();
				echo $u;
				return;
			}
		}
	}
	http_response_code( 302 );
	header( "Location: /profile/me/" );
?>
