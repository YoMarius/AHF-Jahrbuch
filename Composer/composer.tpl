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
		<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.7/js/materialize.min.js"></script>
		<script type="text/javascript" src="https://oss.maxcdn.com/jquery.form/3.50/jquery.form.min.js"></script>
		<script>

			$(".button-collapse").sideNav();
			$(document).ready(function(){
					$(".modal-trigger").leanModal();

						var c = $('#submember, #remmember, #grantModbtn, #revokeModbtn'); // upload button
					  var b = $('#senden'); // upload button
				  b.click(function(){
						var f = $('#imguploader');

						var p = $('#preview'); // preview area
						var l = $('#loading');
				    // implement with ajaxForm Plugin
				    f.ajaxForm({
				      beforeSend: function(){
				        b.attr('disabled', 'disabled');
				        p.fadeOut();
								l.fadeIn();
				      },
				      success: function(e){
				        f.resetForm();
				        b.removeAttr('disabled');
								l.fadeOut();
				        p.html(e).fadeIn();

				      },
				      error: function(e){
				        b.removeAttr('disabled');
				        p.html(e).fadeIn();
				      }
				    });
				  });

					c.click(function(){
						var addmem = $('#addmem, #remmem, #grantMod, #revokeMod');
						var l = $('#loading');
				    // implement with ajaxForm Plugin
				    addmem.ajaxForm({
				      beforeSend: function(){
				        c.attr('disabled', 'disabled');
								l.fadeIn();
				      },
				      success: function(e){
				        addmem.resetForm();
								Materialize.toast('Erledigt!', 4000)
				        c.removeAttr('disabled');
								l.fadeOut();

				      },
				      error: function(e){
				        c.removeAttr('disabled');
								l.fadeOut();
				      }
				    });
				  });

			  });



		</script>
	</body>
</html>
