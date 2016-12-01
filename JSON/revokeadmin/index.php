<?php require_once $_SERVER["DOCUMENT_ROOT"]."/Core/log.php"; require_once $_SERVER["DOCUMENT_ROOT"]."/Core/login.php";
	if( !($user = $_GET["user"]) ) { echo "false"; return; }
	echo Login::revokeAdmin( $user, Login::checkUser()["user_id"] )?"true":"false";
?>
