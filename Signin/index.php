<?php require_once( $_SERVER["DOCUMENT_ROOT"]."/Core/index.php" );
	$u = Login::checkUser();
	if( $u ) {
		header( "Location: /profile/".$u["user_id"] );
	}
	else {
		define( "CMSLOADSUBTPL", "login.tpl" );
		if( isset( $_POST["loginhash"] ) ) {
			$l = new Login( $_POST["loginhash"] );
			if( !$l->getError() ) {
				header( "Location: /profile/".$l->user );
				return;
			}
			else {
				define( "LOGINERROR", $l->getErrorMessage() );
			}
		}
		else {
			define( "LOGINERROR", false );
		}
		
		require_once( "../Composer/composer.tpl" );
	}
?>
