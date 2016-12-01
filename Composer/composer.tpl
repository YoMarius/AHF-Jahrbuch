<?php require_once $_SERVER["DOCUMENT_ROOT"]."/Core/index.php"; $login_user = Login::checkUser(); ?>
<!DOCTYPE html>
<html>
	<head>
		<link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.7/css/materialize.min.css">
		<link rel="stylesheet" href="/main.css">
		<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	</head>
	<body>
		<?php require_once "nav.tpl"; ?>
		<?php require_once CMSLOADSUBTPL; ?>
		<script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.7/js/materialize.min.js"></script>
		<script>
			$(".button-collapse").sideNav();
		</script>
	</body>
</html>
