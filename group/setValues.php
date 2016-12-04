<?php require_once $_SERVER["DOCUMENT_ROOT"]."/Core/index.php";
	if( count( $_POST ) > 0 ) {
		$usr = Login::checkUser()["user_id"];
		$g = isset($_POST["group"])?$_POST["group"]:"";
		if( Group::isMod($g, $usr) ) {
			if( isset($_POST["newgroup"]) ) {
				$g = (Group::addGroup( $_POST["name"], $_POST["desc"] ))->getID();
				http_response_code( 302 );
				header( "Location: /group/$g/" );
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
			if( isset($_POST["addmember"]) ) {
				$gr = new Group( $g ); $u = $_POST["addmember"];
				$gr->addMember( $u );
				$log( "GROUP", "$usr added $u to Group($g)".$gr->getName() );
				http_response_code( 302 );
				header( "Location: /group/$g/" );
				return;
			}
			if( isset($_POST["removeMember"])) {
            	$u = $_POST["removeMember"];
            	$gr->removeMember( $usr, $u, $g );
            	http_response_code( 302 );
				header( "Location: /group/$g/" );
				return;
            }
            if( isset($_POST["grantMod"])) {
		        $u = $_POST["grantMod"];
		        Group::grantMod(  $usr, $u, $g );
            	http_response_code( 302 );
				header( "Location: /group/$g/" );
				return;
            }
            if( isset($_POST["revokeMod"])) {
             	$u = $_POST["revokeMod"];
		        Group::revokeMod(  $usr, $u, $g );
		    	http_response_code( 302 );
				header( "Location: /group/$g/" );
				return;
            }
                        

		}
	}
	http_response_code( 302 );
	header( "Location: /profile/me/" );
?>
